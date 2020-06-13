//
//  SafeFrameUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

class SafeFrameUtil{
    
    static func getSafeAreaTop() -> CGFloat{
        var top:CGFloat = 0
        
        if #available(iOS 11.0, *){
            top = AppDelegate.shared.window!.safeAreaInsets.top
        }
        
        if (top == 0) {
            top = 20;
        }
        
        return top
    }
    
    static func getSafeAreaBottom() -> CGFloat{
        
        var bottom:CGFloat = 0
        
        if #available(iOS 11.0, *){
            bottom = AppDelegate.shared.window!.safeAreaInsets.bottom
        }
        return bottom
    }
    
}
