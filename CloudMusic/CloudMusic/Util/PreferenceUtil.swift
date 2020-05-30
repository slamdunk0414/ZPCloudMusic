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

}
