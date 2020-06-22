//
//  KSCLyricParser.swift
//  KSC歌词解析器
//
//  Created by 张鹏 on 2020/6/22.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class KSCLyricParser {
    static func parse(_ style:LyricType,_ data:String) -> Lyric {
        //创建结果对象
        let result = Lyric()
        
        //设置为精确到字歌词
        result.isAccurate = true
        
        //创建一个数组
        result.datas = []
        
        //使用\n拆分歌词
        let strings = data.components(separatedBy: "\n")
        
        //循环解析每一行歌词
        for line in strings {
            if let lyricLine = parseLine(line) {
                result.datas.append(lyricLine)
            }
        }
        
        return result
    }
    
    /// 解析每一行歌词
    /// 例如：karaoke.add('00:27.487', '00:32.068', '一时失志不免怨叹', '347,373,1077,320,344,386,638,1096');
    ///
    /// - Parameter data: <#data description#>
    /// - Returns: <#return value description#>
    static func parseLine(_ data:String) -> LyricLine? {
        if data.hasPrefix("karaoke.add('") {
            //过滤了前面的元数据
            
            //创建结果对象
            let lyricLine = LyricLine()
            
            //移除字符串前面的karaoke.add('
            //移除字符串后面的');
            //newData=00:27.487', '00:32.068', '一时失志不免怨叹', '347,373,1077,320,344,386,638,1096
            let newData = data[13..<data.count-3]
            
            //使用', '拆分字符串
            let commnds = newData.components(separatedBy: "', '")
            
            //开始时间
            lyricLine.startTime = TimeUtil.parseToInt(commnds[0])
            
            //结束时间
            lyricLine.endTime = TimeUtil.parseToInt(commnds[1])
            
            //歌词
            lyricLine.data = commnds[2]
            
            //将歌词拆分为每一个字
            lyricLine.words = lyricLine.data.words()
            
            //每一个字的时间
            lyricLine.wordDurations = []
            
            let lyricTimeString = commnds[3]
            
            //使用,拆分
            let lyricTimeWords = lyricTimeString.components(separatedBy: ",")
            
            //将字符串时间转为int
            for item in lyricTimeWords {
                lyricLine.wordDurations!.append(Int(item)!)
            }
            
            return lyricLine
            
        }
        
        return nil
    }
}
