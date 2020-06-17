//
//  Song.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class Song:BaseModel{

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
    
    /// 是否在播放列表中
    var playList = false
    
    /// 将Song转为SongLocal对象
    ///
    /// - Returns: <#return value description#>
    func toSongLocal() -> SongLocal {
        //创建一个对象
        let songLocal = SongLocal()
        
        //将要保存的字段赋值到songLocal对象
        songLocal.id = id
        songLocal.title=title
        songLocal.banner = banner
        songLocal.uri=uri
//        songLocal.singer_id = singer.id
        songLocal.singer_nickname=singer.nickname
//        songLocal.singer_avatar=singer.avatar
        songLocal.playList=playList
        
        //音乐时长
        songLocal.duration = duration
        
        //播放进度
        songLocal.progress = progress
        
        return songLocal
    }
}

class SongUser:BaseModel{
    /// 昵称
    var nickname:String!
    
    /// 头像
    var avatar:String?
    
    /// 描述
    var description:String?
}
