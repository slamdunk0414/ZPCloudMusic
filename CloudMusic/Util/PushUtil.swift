//
//  ZPPushTool.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class PushUtil{
    
    static func setRootController(controller: UIViewController) {
        
        AppDelegate.shared.window?.rootViewController = controller
        
    }
    
    static func onLogin(session:Session){
        
        Defaults[.userid_key] = session.user
        Defaults[.usertoken_key] = session.session

        //跳转到首页
        toHome()
    }
    
    static func toHome(){
        self.setRootController(controller: MainViewController())
    }
    
    static func toLogin(){
        let navi = UINavigationController(rootViewController: ZPLoginOrRegisterViewController())
        
        self.setRootController(controller:navi)
    }

}
