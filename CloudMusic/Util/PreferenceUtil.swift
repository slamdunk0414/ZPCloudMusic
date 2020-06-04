//
//  PreferenceUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class PreferenceUtil{
    
    static func isShowGuide() -> Bool {

        let infoDictionary = Bundle.main.infoDictionary
        
        let app_Version:String = infoDictionary?["CFBundleShortVersionString"] as! String

        let hasShowGuide:Bool = Defaults.bool(forKey: zGuide_key + app_Version)
        
        return hasShowGuide
    }
    
    static func setShowGuide(hasShowGuide:Bool){
        
        let infoDictionary = Bundle.main.infoDictionary
        
        let app_Version:String = infoDictionary?["CFBundleShortVersionString"] as! String
        
        Defaults.set(hasShowGuide, forKey: zGuide_key + app_Version)

    }

    
    // MARK: - 用户相关
    /// 保存用户Id
    ///
    /// - Parameter data: <#data description#>
    static func setUserId(_ data:String) {
        Defaults[.userid_key] = data
    }
    
    /// 获取用户Id
    ///
    /// - Returns: <#return value description#>
    static func userId() -> String? {
        
        if let userId = Defaults[.userid_key]{
            
            if !userId.isEmpty{
                return userId
            }
            
        }
        
        return nil
        
        
    }
    
    /// 保存用户会话标识
    ///
    /// - Parameter data: <#data description#>
    static func setUserToken(_ data:String) {
        Defaults[.usertoken_key] = data
    }
    
    /// 获取用户会话标识
    ///
    /// - Returns: <#return value description#>
    static func userToken() -> String {
        return Defaults[.usertoken_key]!
    }
    
    /// 是否登录了
    ///
    /// - Returns: <#return value description#>
    static func isLogin() -> Bool {
        if let _ = userId() {
            return true
        }
        
        return false
    }
}
