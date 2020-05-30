//
//  ZPSplashViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPSplashViewController: UIViewController {

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
            
            let navi = UINavigationController(rootViewController: ZPLoginOrRegisterViewController())
            
            PushUtil.setRootController(controller:navi)
        }else{
            PushUtil.setRootController(controller:ZPGuideViewController())
        }
        
        
//        CustomNetworkUtil.shareProvider.request(CustomNetworkAPI.sheets)
        let _ = CustomNetworkUtil.shareProvider.rx.request(.sheetDetail(id: "1")).mapJSON().subscribe(onSuccess: { (data) in
            
            print(data)
            
        }) { (error) in
            
        }
        
    }

}
