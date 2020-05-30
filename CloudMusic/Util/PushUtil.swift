//
//  ZPPushTool.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class PushUtil{
    
    static func setRootController(controller: UIViewController) {
        
        AppDelegate.shared.window?.rootViewController = controller
        
    }

}
