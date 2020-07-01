//
//  PlayListManager.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/15.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class PlayListManager: NSObject {
    //单例设计模式
    private static var instance :PlayListManager?
    
    /// 播放管理器
    var musicPlayerManager:MusicPlayerManager!
    
    /// 数据库
    var orm:ORMUtil = ORMUtil.shared()
    
    //播放列表
    var datum:[Song] = []
    
    /// 当前播放的音乐
    var data:Song?
    
    /// 是否播放了音乐
    var isPlay = false
    
    /// 循环模式
    var model:MusicPlayerRepeatMode = .list
    
    override init() {
        super.init()
        //初始化播放管理器
        musicPlayerManager = MusicPlayerManager.shared()
        
        initPlayList()
    }
    
   /// 初始化播放列表
   func initPlayList()  {
       //从数据库中查询当前用户的播放列表
       let songs = orm.queryPlayList()
       
       //判断有没有播放列表
       if songs.count > 0 {
           //有播放列表
           
           //添加到播放列表
           datum = datum + songs
           
           //获取上一次播放的这首音乐
           let songId = PreferenceUtil.lastPlaySongId()
           
           if let songId = songId {
               //上一次有播放音乐
               
               //找到上一次播放的音乐
               for song in songs {
                   if song.id == songId {
                       data = song
                       break
                   }

               }
               
               if let data = data {
                   //找到了
                   setMusicPlayerManagerData(data)
               }else {
                   //没找到
                   //可能各种原因
                   defaultPlaySong()
               }
           }else {
               //设置默认音乐
               defaultPlaySong()
           }
       }
   }
    /// 设置默认播放的音乐
    func defaultPlaySong() {
        data = datum[0]
        
        setMusicPlayerManagerData(data!)
    }
    
    /// 设置音乐对象到播放管理器
    ///
    /// - Parameter data: <#data description#>
    func setMusicPlayerManagerData(_ data:Song) {
        musicPlayerManager.data = data
    }
    
    static func shared() -> PlayListManager {
        if instance == nil {
            instance = PlayListManager()
        }
        return instance!
    }
    
    /// 播放当前位置的音乐
    ///
    /// - Parameter position: <#position description#>
    func play(_ position:Int) {
        print("PlayListManager play:\(position)")
        
        let data = datum[position]
        
        play(data)
    }
    
    /// 设置播放列表
    ///
    /// - Parameter datum: <#datum description#>
    func setPlayList(_ datum:[Song]) {
        print("PlayListManager setPlayList")

        //将原来的播放列表数据中的playList标记清除
        DataUtil.changePlayListFlag(self.datum, false)
        saveAll()
        
        //清空原来的数据
        self.datum.removeAll()
        
        //添加新的数据
        self.datum = self.datum+datum
        
        DataUtil.changePlayListFlag(self.datum, true)
        saveAll()
    }
    
    /// 保存播放列表
    func saveAll() {
        for song in datum {
            orm.saveSong(song)
        }
    }
    
    /// 获取播放列表
    ///
    /// - Returns: <#return value description#>
    func getPlayList() -> [Song] {
        print("PlayListManager getPlayList")
        return datum
    }
    
    /// 播放当前音乐
    ///
    /// - Parameter data: <#data description#>
    func play(_ data:Song) {
        
        self.data = data
        
//        musicPlayerManager.play(data)
        
        //查询是否有下载任务
        let downloadInfo = DownloadManager.sharedInstance().findDownloadInfo("\(data.id!)")

        if downloadInfo != nil && downloadInfo.status == .completed  {
            //下载完成了
            data.uri = downloadInfo.absolutePath()
            //播放本地音乐
            musicPlayerManager.play(data)

            print("PlayListManager play offline:\(downloadInfo.absolutePath()),\(data.uri)")
        }else {
            //播放在线音乐

            musicPlayerManager.play(data)

            print("PlayListManager play online:\(data.uri)")
        }
        
        //标记为播放了
        isPlay = true
        
    }
    
    func playOrPause(){
        if musicPlayerManager.isPlaying() {
            pause()
        }else{
            resume()
        }
    }
    
    /// 暂停
    func pause() {
        print("PlayListManager pause")
        musicPlayerManager.pause()
    }
    
    /// 继续播放
    func resume() {
        print("PlayListManager resume")
        
        if isPlay {
            //播放管理器已经播放过音乐了
            musicPlayerManager.resume()
        } else {
            //还没有进行播放
            //第一次打开应用点击继续播放
            play(data!)
            
            //继续播放
            if data!.progress > 1 {
                //有播放记录
                //继续播放
                musicPlayerManager.seekTo(data!.progress-1)
            }
        }
    }
    
    /// 从指定位置开始播放
    ///
    /// - Parameter value: <#value description#>
    func seekTo(_ value:Float) {
        musicPlayerManager.seekTo(value)
        
        //如果暂停了就继续播放
        if !musicPlayerManager.isPlaying() {
            resume()
        }
    }
    
    /// 上一曲
    ///
    /// - Returns: <#return value description#>
    func previous() -> Song {
        var index = 0
        
        switch model {
        case .random:
            //随机循环
            index = Int(arc4random()) % datum.count
            
        case .one:
            //其他模式
            let datumOC = datum as NSArray
            index = datumOC.index(of: data!)
            print("PlayListManager previous index:\(index)")
            datum[index].progress = 0
            
            return datum[index]
            
        default:
            //其他模式
            let datumOC = datum as NSArray
            index = datumOC.index(of: data!)
            
            if index != -1 {
                //找到了
                
                //判断当前播放的音乐是不是第一首音乐
                if index == 0{
                    //当前播放的是第一首音乐
                    index = datum.count - 1
                }else {
                    index -= 1
                }
            }else{
                //抛出异常
                //因为正常情况下不会走到了
            }
            
        }
        
        print("PlayListManager previous index:\(index)")
        datum[index].progress = 0
        
        return datum[index]
    }
    
    /// 下一曲
    ///
    /// - Returns: <#return value description#>
    func next() -> Song {
        var index = 0
        
        switch model {
        case .random:
            //随机循环
            index = Int(arc4random()) % datum.count
        case .one:
            //列表循环
            let datumOC = datum as NSArray
            index = datumOC.index(of: data!)
            
            print("PlayListManager next index:\(index)")
            datum[index].progress = 0
            
            return datum[index]
            
        default:
            //列表循环
            let datumOC = datum as NSArray
            index = datumOC.index(of: data!)
            
            if index != -1 {
                //找到了
                
                //如果当前播放的音乐是最后一首音乐
                if index == datum.count - 1 {
                    //当前播放的是最后一首音乐
                    index = 0
                }else {
                    index += 1
                }
            }else{
                //抛出异常
                //因为正常情况下不会走到了
            }
        }
        
        print("PlayListManager next index:\(index)")
        datum[index].progress = 0
        
        return datum[index]
    }
    
    /// 切换循环模式
    ///
    /// - Returns: <#return value description#>
    func changeLoopMode() -> MusicPlayerRepeatMode {
        //将当前循环模式转为int
        var model = self.model.rawValue
        
        //循环模式+1
        model += 1
        
        //判断边界
        if model > MusicPlayerRepeatMode.random.rawValue {
            //超出了范围
            model = 0
        }
        
        self.model = MusicPlayerRepeatMode(rawValue: model)!
        
        return self.model
    }
    
    /// 获取当前循环模式
    ///
    /// - Returns: <#return value description#>
    func getLoopModel() -> MusicPlayerRepeatMode {
        return model
    }
    
    func saveSong(){
        if let data = data {
            //有音乐才保存
            
            //保存当前音乐信息到数据库
            orm.saveSong(data)
            
            //保存当前音乐的Id到配置文件
            PreferenceUtil.setLastPlaySongId(data.id)
        }
    }
}



/// 循环模式
///
/// - list: 列表循环
/// - one: 单曲循环
/// - random: 随机循环
enum MusicPlayerRepeatMode:Int {
    case list = 0
    case one
    case random
}

