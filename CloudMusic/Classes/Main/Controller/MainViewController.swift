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
        let video = getNavigationControllerWithChildViewController(VideoController(), name: "视频", iconName: "TabVideo")
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


extension MainViewController {
    
    //这里，如果selectedViewController是navigationController，因为navigationController也是返回它的topViewController的状态，所以最终还是各个viewController自己来控制自己的状态
    
    open override var shouldAutorotate: Bool {
        if let tempViewController = self.selectedViewController {
            return tempViewController.shouldAutorotate
        } else {
            return false
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let tempViewController = self.selectedViewController {
            return tempViewController.supportedInterfaceOrientations
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let tempViewController = self.selectedViewController {
            return tempViewController.preferredInterfaceOrientationForPresentation
        } else {
            return UIInterfaceOrientation.portrait
        }
    }
}
