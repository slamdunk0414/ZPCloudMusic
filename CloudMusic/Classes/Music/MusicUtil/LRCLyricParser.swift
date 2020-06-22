//
//  LRCLyricParser.swift
//  LRC歌词解析器
//
//  Created by 张鹏 on 2020/6/22.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class LRCLyricParser {
    static func parse(_ style:LyricType,_ data:String) -> Lyric {
        //创建歌词解析后的对象
        let result = Lyric()
        
        //初始化一个数组
        result.datas = []
        
        //使用\n拆分歌词
        let strings = data.components(separatedBy: "\n")
        
        //循环每一行歌词
        for line in strings {
            //解析每一行歌词
            if let lyricLine = parseLine(line) {
                //过滤了空行歌词
                result.datas.append(lyricLine)
            }
        }
        
        return result
    }
    
    /// 解析一行歌词
    /// 例如：[00:00.300]爱的代价 - 李宗盛
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func parseLine(_ data:String) -> LyricLine? {
        
        //过滤元数据
        if data.hasPrefix("[0") {
            //创建一个LyricLine
            let lyricLine = LyricLine()
            
            //去处前面的[
            let data = data.substring(fromIndex: 1)
            
            //使用]拆分
            let commands = data.components(separatedBy: "]")
            
            //开始时间
            lyricLine.startTime = TimeUtil.parseToInt(commands[0])
            
            //歌词
            lyricLine.data = commands[1]
            
            return lyricLine
        }
        
        return nil
    }
}
