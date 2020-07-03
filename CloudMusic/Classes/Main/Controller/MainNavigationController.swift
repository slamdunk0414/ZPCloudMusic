//
//  MainNavigationController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
    }
}

extension MainNavigationController{
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "1", style: .done, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
        
    }
}

extension MainNavigationController {
    //这里只需要返回self.topViewController的相应属性，让各个viewController自己控制就行了
    //present出来的viewController本来就是受自己控制，跟nav无关
    
    open override var shouldAutorotate: Bool {
        if let viewController = self.topViewController {
            return viewController.shouldAutorotate
        } else {
            return false
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let viewController = self.topViewController {
            return viewController.supportedInterfaceOrientations
        }  else {
            return .portrait
        }
    }
    
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let viewController = self.topViewController {
            return viewController.preferredInterfaceOrientationForPresentation
        }  else {
            return .portrait
        }
    }
}
