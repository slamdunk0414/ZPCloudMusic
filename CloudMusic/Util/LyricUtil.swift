//
//  LyricUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/22.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

class LyricUtil {
    
    /// 计算当前播放时间是哪一行歌词
    ///
    /// - Parameters:
    ///   - lyric: 歌词对象
    ///   - time: 播放时间；单位秒
    /// - Returns: <#return value description#>
    static func getLineNumber(_ lyric:Lyric,_ time:Float) -> Int {
        //将播放时间转为毫秒
        let newTime = time * 1000
        
        //倒序遍历每一行歌词
        for (index,value) in lyric.datas.enumerated().reversed() {
            if newTime >=  Float(value.startTime) {
                //print("LyricUtil getLineNumber:\(newTime),\(index)")
                
                //就是这一行歌词
                return index
            }
        }
        
        return 0
    }
    
}


