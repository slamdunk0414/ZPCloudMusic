//
//  DefaultKeys.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

let zGuide_key = "guide_key"
let zUSERID_key = "userid_key"
let zUSERTOKEN_Key = "usertoken_key"

extension DefaultsKeys {
    
    static let guide_key = DefaultsKey<Bool?>(zGuide_key)
    static let userid_key = DefaultsKey<String?>(zUSERID_key)
    static let usertoken_key = DefaultsKey<String?>(zUSERTOKEN_Key)
    
}
