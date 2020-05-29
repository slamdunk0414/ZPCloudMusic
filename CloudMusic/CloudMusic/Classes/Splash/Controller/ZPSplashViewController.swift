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
        
        let guide = ZPGuideViewController.init()

        let appDelegate = AppDelegate.shared
        appDelegate.window?.rootViewController = guide
    }

}
