//
//  DataManager.swift
//  FlowSample
//
//  Created by nadioo on 2018/12/19.
//  Copyright © 2018 hogehoge. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    // 0~300の文字列配列
    var playlist: [String] = [Int](0...300).map { String($0) }
    
    /**
     *  AccessTokenのvalidationを行う
     *  @param completion errorの場合、error情報をコールバックする
     */
    func validateAccessToken(completion:((Error?) -> Void)) {
        completion(nil)
    }
    
    /**
     *  loginを行う
     *  @param completion errorの場合、error情報をコールバックする
     */
    func login(completion:((Error?) -> Void)) {
        completion(nil)
    }
    
    /**
     *  プレイリスト情報を取得する
     *  @param offset offset値から+20件の情報を取得する
     *  @param completion (プレイリスト情報、次の情報があるかフラグ、error)をコールバックする
     */
    func getPlaylistData(offset: Int, completion:(([String], Bool, Error?) -> Void)) {
        if offset + 20 > playlist.count {
            completion(Array(playlist[offset...300]), false, nil)
        } else {
            completion(Array(playlist[offset..<offset + 20]), true, nil)
        }
    }
}
