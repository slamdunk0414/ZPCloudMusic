//
//  TimeUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

class TimeUtil {

    /// 将秒转为分秒格式
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: 格式为：10:20
    static func second2MinuteAndSecond(_ value:Float) -> String {
        let minute = Int(value/60)
        let second = Int(value) % 60
    
        return String(format: "%02d:%02d", minute,second)
    }
}
