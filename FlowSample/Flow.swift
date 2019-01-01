//
//  Flow.swift
//  FlowSample
//
//  Created by nadioo on 2018/12/19.
//  Copyright © 2018 hogehoge. All rights reserved.
//

import UIKit

class Flow: NSObject {

    let manager = DataManager()
    
    // task
    var reserve: Selector?
    
    // callback
    var failed: ((Error) -> Void)?
    var dataCompletion: (() -> Void)?
    var needLogin: (() -> Void)?
    var loginSuccess: (() -> Void)?
    
    // argument
    var offset: Int = 0
    
    // プレイリスト情報
    var playlist: [String] = []
    // 続きのプレイリスト情報があるかどうか
    var isNext = false
    
    // MARK: Flow Task
    
    /**
     *  Flowを開始するときに呼ばれる
     */
    func startFlow(failed: ((Error) -> Void)?,
                   dataCompletion: (() -> Void)?,
                   needLogin: (() -> Void)?,
                   loginSuccess: (() -> Void)?) {
        self.failed = failed
        self.dataCompletion = dataCompletion
        self.needLogin = needLogin
        self.loginSuccess = loginSuccess
        // はじめのタスクを実行
        doNext(#selector(validateAccessToken))
    }

    /**
     *  AccessTokenのvalidationを行う
     *  AccessTokenが有効の場合は、プレイリスト情報を取得する
     *  AccessTokenが無効の場合は、ログイン画面を表示する
     */
    @objc func validateAccessToken() {
        manager.validateAccessToken(completion: { [unowned self] (error) in
            if error == nil {
                // accessTokenが有効の場合は、プレイリスト情報を取得する
                doNext(#selector(self.getPlaylistData))
            } else {
                // 期限切れのaccessTokenの場合はログイン画面を表示する（※ネットワークエラー等との区別が必要）
                setReserve(#selector(self.login))
                // UIにログイン画面を表示するように指示
                needLogin?()
            }
        })
    }
    
    /**
     *  AccessTokenが無効の場合にログイン処理を行う
     *  ログインに成功した場合は、プレイリスト情報を取得する
     *  ログインに失敗した場合は、エラーアラート等を表示する
     */
    @objc func login() {
        manager.login(completion: { [unowned self] (error) in
            if error == nil {
                // loginに成功したらreserveをnilにする
                reserve = nil
                // 次のタスクをセット
                setReserve(#selector(self.getPlaylistData))
                // ログイン成功をUIに通知
                loginSuccess?()
            } else {
                // ログイン失敗アラート等
                failed?(error!)
            }
        })
    }
    
    /**
     *  プレイリスト情報を取得する
     *  プレイリスト情報の取得に成功した場合は、UIにプレイリスト情報を送る
     *  続きの情報がある場合は、UIに続きの情報があることを知らせる
     */
    @objc func getPlaylistData() {
        manager.getPlaylistData(offset: offset, completion: { [unowned self] (playlist, isNext, error) in
            if error == nil {
                // 取得に成功したらreserveをnilにする
                reserve = nil
                // データが取得できたらtableViewに表示する
                self.playlist = self.playlist + playlist
                self.isNext = isNext
                if isNext {
                    // 次に取得するオフセット値を設定する
                    offset = self.playlist.count
                    // 次のタスクをセット
                    setReserve(#selector(self.getPlaylistData))
                }
                // データをUIに送信
                dataCompletion?()
            } else {
                // 取得失敗
                failed?(error!)
            }
        })
    }
    
    // MARK: Private Method
    
    private func doNext(_ selector: Selector) {
        perform(selector)
    }
    
    private func setReserve(_ selector: Selector) {
        reserve = selector
    }
    
    // MARK: Public Method
    
    func doReserveTask() {
        guard reserve != nil else { return }
        perform(reserve)
    }
}
