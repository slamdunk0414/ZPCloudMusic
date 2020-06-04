//
//  ZPLoginViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPLoginViewController: ZPBaseLoginController {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登录"
        
        loginButton.layer.cornerRadius = 22
        loginButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func onLoginClick(_ sender: Any) {
        
        //获取用户名
        let username = phoneTextField.text!.trim()
                
        if username.isEmpty {
            ToastUtil.short("请输入用户名！")
            return
        }
        
        var isPhone = false
        if username =~ .tel {
            isPhone = true
        }else if username =~ .email{
            isPhone = false
        }else{
            ToastUtil.short("用户名格式不正确")
        }
        
        //获取密码
        let password=passWordTextField.text!.trim()
        
        if password.isEmpty {
            ToastUtil.short("请输入密码！")
            return
        }
        
        guard password =~ .password else {
            ToastUtil.short("密码格式不正确")
            return
        }
        
        if isPhone {
            //手机号
            login(phone: username, password: password)
        } else {
            //邮箱
            login( email: username, password: password)
        }

    }
}
