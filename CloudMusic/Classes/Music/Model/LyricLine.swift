//
//  LyricLine.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/22.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

/// 单位都是毫秒
class LyricLine {
    
    /// 这一行歌词的内容
    var data:String!
    
    /// 开始时间
    var startTime:Int = 0
    
    /// 每一个字
    var words:[String]?
    
    /// 每一个字对一个的时间
    var wordDurations:[Int]?
    
    /// 结束时间
    var endTime:Int = 0
    
    
}
