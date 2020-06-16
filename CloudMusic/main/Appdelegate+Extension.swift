//
//  Appdelegate+Extension.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/16.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

extension AppDelegate{
    
    func initMedia(){
        //告诉系统
        //我们要接收远程控制事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
               
        //设置响应者
        becomeFirstResponder()
    }
    
    // MARK: - 远程控制事件
    //表示我们当前这个应用是第一响应者
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
}
