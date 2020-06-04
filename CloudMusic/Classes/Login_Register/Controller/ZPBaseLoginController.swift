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

        CustomNetworkUtil.shared.login(phone: phone, email: email, password: password, qq_id: qq_id, weibo_id: weibo_id).subscribe({ (data) in
            
            if let data = data?.data{
                PushUtil.onLogin(session: data)
            }

        }) { (error) in
            
            print("登录失败")
            
        }
    }
}
