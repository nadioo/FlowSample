//
//  ViewController.swift
//  FlowSample
//
//  Created by nadioo on 2018/12/19.
//  Copyright © 2018 hogehoge. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoginDelegate {

    @IBOutlet weak var tableView: UITableView!
    // flow
    let flow = Flow()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Flowの開始
        flow.startFlow(failed: { (error) in
            // エラーアラート等
            
        }, dataCompletion: { 
            // TableViewをリロード
            self.tableView.reloadData()
        }, needLogin: {
            // ログイン画面を開く
            self.performSegue(withIdentifier: "login", sender: nil)
        }, loginSuccess:{
            // ログイン画面を閉じてプレイリスト情報を取得する
            self.presentedViewController?.dismiss(animated: true, completion: {
                self.flow.doReserveTask()
            })
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flow.isNext {
            // 続きの取得情報がある場合は、最後のセルを続きのプレイリスト取得セルにする
            return flow.playlist.count + 1
        } else {
            return flow.playlist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if indexPath.row == flow.playlist.count {
            // 最後のセルが表示されたら次の情報を取得する
            flow.doReserveTask()
        } else {
            // セルに内容を表示
            cell.textLabel?.text = flow.playlist[indexPath.row]
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            let lvc = segue.destination as! LoginViewController
            lvc.delegate = self
        }
    }
    
    func login() {
        // フローでログイン処理を実行
        flow.doReserveTask()
    }
}

