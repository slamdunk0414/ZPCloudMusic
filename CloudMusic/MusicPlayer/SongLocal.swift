//
//  SongLocal.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/17.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

//导入数据库框架
import Realm
import RealmSwift

class SongLocal: Object {

    /// 对象Id
    @objc dynamic var id:String = ""
    
    /// 标题
    @objc dynamic var title:String = ""
    
    /// 大图
    @objc dynamic var banner:String = ""
    
    /// 歌曲地址
    @objc dynamic var uri:String = ""
    
    /// 歌手Id
    @objc dynamic var singer_id:String = ""
    
    /// 歌手昵称
    @objc dynamic var singer_nickname:String = ""
    
    /// 歌手头像
    @objc dynamic var singer_avatar:String? = nil
    
    /// 是否在播放列表
    /// true:在
    @objc dynamic var playList:Bool = false
    
    /// 设置主键字段
    ///
    /// - Returns: <#return value description#>
    override class func primaryKey() -> String? {
        return "id"
    }

    // MARK: - 播放后才有值
    
    /// 时长
    @objc dynamic var duration:Float = 0
    
    /// 播放进度
    @objc dynamic var progress:Float = 0
    
    /// 将SongLocal转为Song
    ///
    /// - Returns: <#return value description#>
    func toSong() -> Song {
        //创建对象
        let song = Song()
        
        //赋值
        song.id = id
        song.title=title
        song.banner=banner
        song.uri=uri
        
        //歌手
        let singer = SongUser()
        singer.id = singer_id
        singer.nickname=singer_nickname
        singer.avatar=singer_avatar
        
        song.singer = singer
        
        song.playList = playList
        
        //音乐时长
        song.duration = duration
        
        //播放进度
        song.progress = progress
        
        return song
    }
}
