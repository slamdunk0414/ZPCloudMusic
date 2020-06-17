//
//  Appdelegate+Extension.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/16.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

extension AppDelegate{
    
    func initMedia(){
        
        playListManager = PlayListManager.shared()
        musicPlayerManager = MusicPlayerManager.shared()
        
        //告诉系统
        //我们要接收远程控制事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
               
        //设置响应者
        becomeFirstResponder()
    }
    
    // MARK: - 远程控制事件
    //表示我们当前这个应用是第一响应者
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        //判断是不是远程控制事件
        if event?.type == UIEvent.EventType.remoteControl {
            //是远程控制事件
            
            //是否有音乐
            if playListManager!.data == nil {
                //当前播放列表中没有音乐
                return
            }
            
            //判断事件类型
            switch event!.subtype {
            case .remoteControlPlay:
                //点击了播放按钮
                print("AppDelegate play")
                
                playListManager!.resume()
            case .remoteControlPause:
                //点击了暂停
                print("AppDelegate pause")
                
                playListManager!.pause()
            case .remoteControlNextTrack:
                //下一首
                //双击iPhone有线耳机上的控制按钮
                print("AppDelegate next")
                if playListManager!.getPlayList().count > 0{
                    playListManager!.play(playListManager!.next())
                }
            case .remoteControlPreviousTrack:
                //上一首
                //三击iPhone有线耳机上的控制按钮
                print("AppDelegate previouse")
                
                playListManager!.play(playListManager!.previous())
            case .remoteControlTogglePlayPause:
                //单击iPhone有线耳机上的控制按钮
                print("AppDelegate toggle play pause")
                
                //播放或者暂停
                playOrPause()
            default:
                break
            }
        }
    }
    
    /// 播放或暂停
    func playOrPause() {
        if musicPlayerManager.isPlaying() {
            playListManager!.pause()
        } else {
            playListManager!.resume()
        }
    }
    
}
