//
//  ZPSplashViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPSplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.next()
        }
    }
    
    func next(){
        
        let isShowGuide = PreferenceUtil.isShowGuide()
        
        //如果展示了Guide 则直接进入注册登录
        if isShowGuide {
            
            if PreferenceUtil.isLogin(){
                PushUtil.toHome()
            }else{
                PushUtil.toLogin()
            }
        }else{
            PushUtil.setRootController(controller:ZPGuideViewController())
        }
    }
}
