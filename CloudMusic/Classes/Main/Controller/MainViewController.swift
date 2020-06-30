//
//  MainViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewControllers()
    }
    
    func addChildViewControllers() {
        
        let discovery = getNavigationControllerWithChildViewController(ZPHomeViewController(), name: "发现", iconName: "TabDiscovery")
        let video = getNavigationControllerWithChildViewController(ZPHomeViewController(), name: "视频", iconName: "TabVideo")
        let music = getNavigationControllerWithChildViewController(MeViewController(), name: "音乐", iconName: "TabMusic")
        let friend = getNavigationControllerWithChildViewController(ZPHomeViewController(), name: "好友", iconName: "TabFriend")
        let account = getNavigationControllerWithChildViewController(ZPHomeViewController(), name: "我的", iconName: "TabAccount")
        
        self.viewControllers = [discovery,music,video,friend,account]
        
    }
    
    func getNavigationControllerWithChildViewController(_ viewController: UIViewController, name:String, iconName: String) -> UINavigationController{
        
        let navi = MainNavigationController(rootViewController: viewController)
        navi.tabBarItem.title = name
        navi.tabBarItem.image = UIImage(named: iconName)

        self.tabBar.tintColor = .red

        return navi
        
    }

}
