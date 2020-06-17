//
//  AppDelegate.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var playListManager: PlayListManager!
    
    var musicPlayerManager: MusicPlayerManager!
    
    /// 是否自动恢复播放
    var isRsumePlay = false
    
    static var shared :AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initMedia()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        saveLastMusic()
    }
}

