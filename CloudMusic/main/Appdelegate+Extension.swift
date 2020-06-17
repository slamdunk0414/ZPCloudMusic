//
//  Appdelegate+Extension.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/16.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

// 导入媒体
import AVFoundation

extension AppDelegate{
    
    func initMedia(){
        
        playListManager = PlayListManager.shared()
        musicPlayerManager = MusicPlayerManager.shared()
        
        //告诉系统
        //我们要接收远程控制事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
               
        //设置响应者
        becomeFirstResponder()
        
        //监听其他音频中断
        //包括其他软件播放音乐
        //当然播放视频也算
        //拨打电话
        //来电
        NotificationCenter.default.addObserver(self, selector: #selector(onInterruptionChanged(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        //监听耳机插入和拔掉通知
        NotificationCenter.default.addObserver(self, selector: #selector(onAudioRouteChanged(notification:)), name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
     /// 音频输出路径改变了回调
     ///
     /// - Parameter notification: <#notification description#>
     @objc func onAudioRouteChanged(notification:Notification) {
         let userInfo = notification.userInfo
         
         print("AppDelegate onAudioRouteChanged:\(userInfo)")
         
         //获取类型
         let type=userInfo![AVAudioSessionRouteChangeReasonKey] as! Int
         
         //判断类型
         switch type {
         case kAudioSessionRouteChangeReason_NewDeviceAvailable:
             //新增了设备
             print("AppDelegate onAudioRouteChanged new device available")
         case kAudioSessionRouteChangeReason_OldDeviceUnavailable:
             //移除了设备
             print("AppDelegate onAudioRouteChanged old device unavailable:\(PreferenceUtil.isRemoveHeadsetStopMusic())")

                 //这里是子线程
                 DispatchQueue.main.async {
                     //切换到主线程

                     //因为播放管理器中会回调界面

                     if PreferenceUtil.isRemoveHeadsetStopMusic(){
                         if self.musicPlayerManager.isPlaying(){
                             //有音乐正在播放

                             //暂停
                             self.playListManager?.pause()
                         }
                     }else {
                         //如果不停止
                         
                         //就继续播放
                         self.playListManager?.resume()
    
                     }
                 }
             
         default:
             break
         }
     }
    
    /// 音频中断了
    /// 包括其他软件播放音频
    /// 来电话了；拨打电话等
    ///
    /// - Parameter notification: <#notification description#>
    @objc func onInterruptionChanged(notification:Notification) {
        print("AppDelegate onInterruptionChanged")
        
        //将三个变量都拆包
        //如果有一个变量拆包失败
        //就直接返回了
        guard let userInfo = notification.userInfo,
            let interruptionTypeRawValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeRawValue) else {
            return
        }
        
        switch interruptionType {
        case .began:
            //中断事件开始
            //例如：播放电话，或者接听电话
            print("AppDelegate onInterruptionChanged began")
            
            if musicPlayerManager.isPlaying() {
                //音乐在播放
                
                //暂停
                playListManager!.pause()
                
                //自动恢复播放
                isRsumePlay = true
            }
        case .ended:
            //中断事件结束了
            //例如：挂断电话
            print("AppDelegate onInterruptionChanged ended")
            
            if isRsumePlay {
                //自动恢复播放
                playListManager!.resume()
                
                //清除自动播放标记
                isRsumePlay = false
            }
        default:
            break
        }
        
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
    
    func saveLastMusic(){
        playListManager?.saveSong()
    }
    
}
