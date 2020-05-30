//
//  ZPLoginOrRegisterViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPLoginOrRegisterViewController: UIViewController {

    @IBAction func loginClick(_ sender: UIButton) {
        
        let controller =  ZPLoginViewController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func registerClick(_ sender: UIButton) {
        
        print("注册点击了")
        
        let controller =  ZPRegisterViewController()
        navigationController?.pushViewController(controller, animated: true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        view.backgroundColor = .blue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
