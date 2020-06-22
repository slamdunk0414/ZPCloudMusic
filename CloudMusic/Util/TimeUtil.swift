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
    
    /// 将分秒毫秒数据转为毫秒
    ///
    /// - Parameter data: 格式为：00:06.429
    /// - Returns: <#return value description#>
    static func parseToInt(_ data:String) -> Int {
        //将:替换.
        let value = data.replacingOccurrences(of: ":", with: ".")
        
        //使用.拆分
        let strings = value.components(separatedBy: ".")
        
        //分别取出分秒毫秒
        let m = Int(strings[0])!
        let s = Int(strings[1])!
        let ms = Int(strings[2])!
        
        //转为毫秒
        return (m*60+s) * 1000 + ms
    }
}
