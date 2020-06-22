//
//  LyricParser.swift
//  歌词解析器
//
//  Created by 张鹏 on 2020/6/22.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class LyricParser {
    
    /// 解析歌词
    ///
    /// - Parameters:
    ///   - style: 歌词类型
    ///   - data: 歌词内容
    /// - Returns: 解析后的歌词对象
    static func parse(_ style:LyricType,_ data:String) -> Lyric {
        switch style {
        case .ksc:
            return KSCLyricParser.parse(style, data)
        default:
            //默认为LRC歌词
            return LRCLyricParser.parse(style, data)
        }
        
    }
}
