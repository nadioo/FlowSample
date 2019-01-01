//
//  LoginViewController.swift
//  FlowSample
//
//  Created by nadioo on 2018/12/21.
//  Copyright © 2018 hogehoge. All rights reserved.
//

import UIKit

// MARK: Delegate
protocol LoginDelegate : NSObjectProtocol {
    func login()
}

class LoginViewController: UIViewController {
    
    var delegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        delegate?.login()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
