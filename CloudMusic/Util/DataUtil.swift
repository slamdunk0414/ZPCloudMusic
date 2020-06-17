//
//  DataUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/17.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

class DataUtil{
    
    /// 更改playList标记
    ///
    /// - Parameters:
    ///   - datum: <#datum description#>
    ///   - playList: <#playList description#>
    static func changePlayListFlag(_ datum:[Song],_ playList:Bool) {
        for data in datum {
            data.playList = playList
        }
    }
    
}
