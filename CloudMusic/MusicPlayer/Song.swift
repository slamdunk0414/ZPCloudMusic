//
//  Song.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class Song{

    /// 标题
    var title:String!
       
    /// 封面图
    var banner:String!
       
    /// 音乐地址
    var uri:String!
    
    // MARK: - 播放后才有值
    /// 时长
    var duration:Float = 0
    
    /// 播放进度
    var progress:Float = 0
    
    /// 歌手
    var singer:SongUser!
}

class SongUser{
    /// 昵称
    var nickname:String!
    
    /// 头像
    var avatar:String?
    
    /// 描述
    var description:String?
}
