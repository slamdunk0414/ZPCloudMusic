//
//  ZPRegisterViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class ZPRegisterViewController: ZPBaseLoginController {

    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var confirmPassWordTextField: UITextField!
    
    
    override func initViews(){
        super.initViews()
        
        self.title = "注册"
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func registerClick(_ sender: Any) {

        let nickName = nickNameTextField.text!.trim()
        
        if nickName.isEmpty {
            ToastUtil.short("请输入昵称")
        }
        
        let phone=phoneNumberTextField.text!.trim()
        
        if phone.isEmpty {
            ToastUtil.short("请输入手机号！")
            return
        }
        
        guard phone =~ .tel else {
            ToastUtil.short("请输入正确的手机号")
            return
        }
        
        //获取邮箱
        let email=emailTextField.text!.trim()

        //为空判断
        if email.isEmpty {
            ToastUtil.short("请输入邮箱！")
            return
        }

        //判断邮箱格式
        guard email =~ .email else {
            ToastUtil.short("邮箱格式不正确！")
            return
        }
        
        //密码
        let password=passWordTextField.text!.trim()

        if password.isEmpty {
            ToastUtil.short("请输入密码！")
            return
        }
        
        guard password =~ .password else {
            ToastUtil.short(ERROR_PASSWORD_FORMAT)
            return
        }
        
        //确认密码
        let confirmPassword=confirmPassWordTextField.text!.trim()

        if confirmPassword.isEmpty {
            ToastUtil.short("请输入确认密码！")
            return
        }
        
        guard confirmPassword =~ .password else {
            ToastUtil.short("确认密码格式不正确！")
            return
        }
        
        //判断确认密码和密码是否一样
        guard password==confirmPassword else {
            ToastUtil.short("两次密码不一致！")
            return
        }
        
        ToastUtil.showLoading("正在注册")
        
        CustomNetworkUtil.shared.createUser(nickname: nickName, phone: phone, email: email, password: password).subscribe({ (response) in
            
            //注册成功后自动登录
            self.login(phone: phone, email: email, password: password)
            
            ToastUtil.hideLoading()
        }) { (error) in
            ToastUtil.hideLoading()
        }
        
    }
    
    @IBAction func xieyiClick(_ sender: Any) {
        print("协议Click")
    }
    
}
