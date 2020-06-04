//
//  ZPBaseLoginController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/4.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit
//导入RxSwift框架
import RxSwift

class ZPBaseLoginController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func login(phone:String?=nil,email:String?=nil,password:String?=nil,qq_id:String?=nil,weibo_id:String?=nil) {

        ToastUtil.showLoading("正在登录")
        
        CustomNetworkUtil.shared.login(phone: phone, email: email, password: password, qq_id: qq_id, weibo_id: weibo_id).subscribe({ (data) in
            
            if let data = data?.data{
                PushUtil.onLogin(session: data)
            }
            
            ToastUtil.hideLoading()

        }) { (error) in
            print("先隐藏loading")
            ToastUtil.hideLoading()
            print("显示失败信息")
            ToastUtil.short(error)
            print("登录失败")
            
        }
    }
}
