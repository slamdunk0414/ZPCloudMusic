//
//  ORMUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/17.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

//导入数据库框架
import Realm
import RealmSwift

class ORMUtil {
    private static var instance:ORMUtil?
    
    /// 数据库
    var database:Realm!
    
    
    /// 单例设计模式
    static func shared() -> ORMUtil {
        if instance == nil {
            instance = ORMUtil()
        }
        
        return instance!
    }
    
    init() {
        //创建数据库
        database = try! Realm()
    }
    
    /// 保存歌曲
    ///
    /// - Parameters:
    func saveSong(_ data:Song) {
        //将Song转为SongLocal
        let songLocal = data.toSongLocal()
        
        //保存数据到数据库
        try! database.write {
            database.add(songLocal, update: .all)
        }
        
        let arr = database.objects(SongLocal.self)
        
    }
    
    /// 查询指定用户的播放列表
    func queryPlayList() -> [Song] {
        //创建一个查询条件字符串
        let whereString = String(format: "playList = 1")
        
        //查询数据
        let songLocals = database.objects(SongLocal.self).filter(whereString)
        
        print("ORMUtil queryPlayList:\(songLocals.count)")
        
        //将songLocal转为Song
        var results:[Song] = []
        
        for songLocal in songLocals {
            //遍历每一个本地音乐对象
            //转成song对象
            let song = songLocal.toSong()
            
            results.append(song)
        }
        
        return results
    }
    
    /// 根据Id查询音乐对象
    func findSongById(_ id:String) -> Song? {
        //创建一个查询条件字符串
        let whereString = String(format: "sid = '%@'", id)
        
        let song = database.objects(SongLocal.self).filter(whereString).first
        
        if let song = song {
            return song.toSong()
        }
        
        return nil
    }
    
    /// 从数据库中删除该音乐
    func deleteSong(_ data:Song) {
        //删除
//        try! database.write {
//            //没找到该框架通过Id删除数据
//            //所有要先查询到要删除的数据
//            //然后在删除
//            let whereString = "user_id = '\(PreferenceUtil.userId()!)' and id = '\(data.id!)'"
//
//            let songLocal = database.objects(SongLocal.self).filter(whereString).first
//
//            if let songLocal = songLocal {
//                //查询到了该音乐
//                database.delete(songLocal)
//            }
//        }
        
        //更新
        let songLocal = data.toSongLocal()

        songLocal.playList = false
        
        try! database.write {
            database.add(songLocal, update: .all)
        }
    }
}
