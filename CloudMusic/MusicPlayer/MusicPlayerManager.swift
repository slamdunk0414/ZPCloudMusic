//
//  MusicPlayerManager.swift
//  音乐管理器
//  封装常用的音乐播放功能 播放 暂停 继续播放等
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

//导入媒体模块
import MediaPlayer

/// 播放状态
///
/// - none: 没有播放
/// - playing: 播放中
/// - pause: 暂停中
/// - error: 播放失败了
enum PlayStatus {
    case none
    case playing
    case loading
    case pause
    case error
}

class MusicPlayerManager:NSObject {
    
    static var STATUS = "status"
    
    private static var instance:MusicPlayerManager?
    
    /// 定时器返回的对象
    var playTimeObserve:Any?
    
    /// 播放状态
    var status:PlayStatus = .none
    
    /// 播放器
    var player:AVPlayer!
    
    /// 当前音乐
    var data:Song!
    
    /// 代理对象
    var delegate:MusicPlayerDelegate?{
        didSet {
             if let _ = self.delegate {
                 //有代理
                 //判断是否有音乐在播放
                 if isPlaying() {
                     //有音乐在播放
                     //启动定时器
                     startPublishProgress()
                 }
             }else {
                 //没有代理
                 //停止定时器
                 stopPublishProgress()
             }
         }
    }
    
    /// 开启进度回调通知
    func startPublishProgress() {
        //判断是否启动了
        if let _  = playTimeObserve {
            //已经启动了
            return
        }
        
        //1/60
        //16毫秒执行一次
        playTimeObserve = player.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1.0), timescale: 10), queue: DispatchQueue.main, using: { time in
            
            //判断是否有代理
            guard let delegate = self.delegate else {
                //没有回调
                //停止定时器
                self.stopPublishProgress()
                return
            }
            let currentTime = CMTimeGetSeconds(self.player.currentItem?.currentTime() ?? CMTime())
            
            //获取当前音乐播放时间
            self.data!.progress = Float(currentTime)
            //回调代理
            delegate.onProgress(self.data)
        })
    }
    
    /// 停止进度分发
    func stopPublishProgress(){
        if let playTimeObserve = playTimeObserve {
            player.removeTimeObserver(playTimeObserve)
            self.playTimeObserve = nil
        }
    }
    
    static func shared() -> MusicPlayerManager{
        if instance == nil {
            instance = MusicPlayerManager()
        }
        return instance!
    }
    
    /// 初始化 初始化player
    override init() {
        super.init()
        
        player=AVPlayer.init()
    }
    
    func play(_ song: Song){
        //保存音乐对象
        self.data = song
        
        self.status = .playing
        
        let uri = song.uri!
        
        var url:URL!
        if uri.hasPrefix("http") {
            //网络地址
            url = URL(string: uri)!
        } else {
            //本地地址
            url = URL(fileURLWithPath: uri)
        }
        
        //创建一个播放Item
        let playerItem = AVPlayerItem(url: url)
        
        //替换掉原来的播放Item
        player.replaceCurrentItem(with: playerItem)
        
        //播放
        player.play()
        
        //回调代理
        delegate?.onPlaying(data!)
        
        //启动进度分发定时器
        startPublishProgress()
        
        //设置监听器
        //因为监听器是针对PlayerItem的
        //所以说播放了音乐在这里设置
        initListeners()
    }
    
    /// 暂停
    func pause() {
        //更改状态
        status = .pause
        
        //暂停
        player.pause()
        
        //回调代理
        delegate?.onPaused(data!)
    }
    
    /// 继续播放
    func resume() {
        //更改播放状态
        status = .playing
        
        //播放
        player.play()
        
        //设置监听器
        initListeners()

        //回调代理
        delegate?.onPlaying(data!)
    }
    
    /// 从指定位置开始播放
    ///
    /// - Parameter value: 跳转到的时间
    func seekTo(_ value:Float) {
        let positionTime = CMTime(seconds: Double(value), preferredTimescale: 1)
        player.seek(to: positionTime)
    }
    
    /// 设置监听器
    func initListeners() {
        //KVO方式监听播放状态
        //KVC:Key-Value Coding,另一种获取对象字段的值，类似字典
        //KVO:Key-Value Observing,建立在KVC基础上，能够观察一个字段值的改变
        player.currentItem?.addObserver(self, forKeyPath: MusicPlayerManager.STATUS, options: .new, context: nil)
        
        //开始缓冲
        player.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        //结束缓冲
        player.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        
        //监听播放结束事件
        NotificationCenter.default.addObserver(self, selector: #selector(onComplete(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    /// 移除监听器
    func removeListeners() {
        player.currentItem?.removeObserver(self, forKeyPath: MusicPlayerManager.STATUS)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 播放完毕了回调
    ///
    /// - Parameter notification: 通知对象
    @objc func onComplete(notification:Notification) {
        print("MusicPlayerManager onComplete")
        delegate?.onComplete(data)
    }
    
    /// KVO监听回调方法
    ///
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("MusicPlayerManager observeValue:\(String(describing: keyPath))")
        
        //判断监听的字段
        if MusicPlayerManager.STATUS == keyPath {
            //播放状态
            switch player.status {
            case .readyToPlay:
                //准备播放完成了
                self.data!.duration = Float(CMTimeGetSeconds(player.currentItem!.asset.duration))
                print("MusicPlayerManager observeValue duration:\(self.data!.duration)")
                //回调代理
                delegate?.onPrepared(data)

            case .failed:
                //播放失败了
                status = .error
                print("MusicPlayerManager observeValue error")
            default:
                //未知状态
                print("MusicPlayerManager observeValue unknown status")
                break
            }
        }else if "playbackBufferEmpty" == keyPath{
            print("正在缓冲")
            delegate?.onLoading(data)
        }else if "playbackLikelyToKeepUp" == keyPath{
            if player.currentItem?.isPlaybackLikelyToKeepUp ?? false {
                print("结束缓冲")
                delegate?.onLoadingSuccess(data)
            }
        }
    }
    
    /// 是否在播放
    ///
    /// - Returns: <#return value description#>
    func isPlaying() -> Bool {
        return status == .playing
    }
}

/// 播放代理
protocol MusicPlayerDelegate {
    
    /// 播放器准备完毕了
    /// 可以获取到音乐总时长
    ///
    /// - Parameter data: 歌曲信息
    func onPrepared(_ data:Song)
    
    /// 暂停了
    ///
    /// - Parameter data: 歌曲信息
    func onPaused(_ data:Song)
    
    /// 正在缓冲数据
    ///
    /// - Parameter data: 歌曲信息
    func onLoading(_ data:Song)
    
    /// 结束缓冲数据
    ///
    /// - Parameter data: 歌曲信息
    func onLoadingSuccess(_ data:Song)
    
    /// 正在播放
    ///
    /// - Parameter data: 歌曲信息
    func onPlaying(_ data:Song)
    
    /// 进度回调
    ///
    /// - Parameter data: 歌曲信息
    func onProgress(_ data:Song)
    
    /// 播放完成
    ///
    /// - Parameter data: 歌曲信息
    func onComplete(_ data:Song)
}
