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
