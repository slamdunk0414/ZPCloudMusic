//
//  VideoPlayerManager.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/7/3.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

//导入媒体框架
import MediaPlayer

class VideoPlayerManager: NSObject {
    
    /// 饿汉式单例
    private static var instance:VideoPlayerManager?
    
    static func shared() -> VideoPlayerManager{
        if instance == nil {
            instance = VideoPlayerManager()
        }
        return instance!
    }
    
    /// 播放器
    var player:AVPlayer!
    
    /// 显示播放视频画面的控件
    var playerLayer:AVPlayerLayer!
    
    /// 状态
    var status:PlayStatus = .none
    
    /// 视频数据
    var data:VideoDetailModel!
    
    /// 进度更新返回的对象
    var playTimeObserver:Any?
    
    var delegate:VideoPlayerDelegate? {
        didSet {
            if let _ = self.delegate {
                //有代理函数
                
                if self.isPlaying() {
                    //正在播放
                    //就启动进度更新
                    startPublishProgress()
                }else {
                    //没有回调函数就停止
                    stopPublishProgress()
                }
            }
        }
    }
    
    
    override init() {
        super.init()
        
        //初始化播放器
        player=AVPlayer.init()
        

    }
    
    /// 播放
    ///
    /// - Parameters:
    ///   - uri: <#uri description#>
    ///   - data: <#data description#>
    func play(_ data:VideoDetailModel) {
        status = .playing
        
        self.data=data
        
        let uri = data.uri!
        
        var url:URL!
        if uri.hasPrefix("http") {
            //网络地址
            url = URL(string: uri)!
        } else {
            //本地地址
            url = URL(fileURLWithPath: uri)
        }
        
        //创建一个播放Item
        let playerItem=AVPlayerItem(url: url)
        
        //替换原来的Item
        player.replaceCurrentItem(with: playerItem)
        
        //创建显示视频画面的控件
        playerLayer=AVPlayerLayer(player: player)
                
        //设置视频缩放模式
        //完全显示：可能有黑边
        //        playerLayer.videoGravity = .resizeAspect
                
        //从中心缩放填充满屏幕
        //没有黑边；但是可能有视频被裁剪了
        playerLayer.videoGravity = .resizeAspectFill
        
        //播放
        player.play()
        
        //设置监听器
        initListeners()
        
        //回调代理
        delegate?.onPlaying(data)
        
        //启动进度通知
        startPublishProgress()
    }
    
    /// 是否在播放
    ///
    /// - Returns: <#return value description#>
    func isPlaying() -> Bool {
        return status == .playing
    }
    
    /// 暂停
    func pause() {
        status = .pause
        
        //移除监听
        removeListeners()
        
        //暂停
        player.pause()
        
        //回调代理
        delegate?.onPaused(data)
        
        //停止进度通知
        stopPublishProgress()
    }
    
    /// 继续播放
    func resume() {
        status = .playing
        
        //重新设置监听
        initListeners()
        
        //播放
        player.play()
        
        //回调代理
        delegate?.onPlaying(data)
        
        //启动进度通知
        startPublishProgress()
    }
    
    /// 从指定位置播放
    ///
    /// - Parameter progress: <#progress description#>
    func seekTo(_ progress:Float) {
       let positionTime = CMTime(seconds: Double(progress), preferredTimescale: 1)
        
        player.seek(to: positionTime)
    }
    
    /// 设置监听器
    func initListeners() {
        //KVO方式监听播放状态
        //KVC:Key-Value Coding,另一种获取对象字段的值，类似字典
        //KVO:Key-Value Observing,建立在KVC基础上，能够观察一个字段值的改变
        
        //监听状态
        player.currentItem?.addObserver(self, forKeyPath: MusicPlayerManager.STATUS, options: .new, context: nil)
        
        //监听缓冲进度
//        player.currentItem?.addObserver(self, forKeyPath: MusicPlayerManage., options: <#T##NSKeyValueObservingOptions#>, context: <#T##UnsafeMutableRawPointer?#>)
        
        //监听播放结束事件
        NotificationCenter.default.addObserver(self, selector: #selector(onComplete(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    /// 移除播放监听
    func removeListeners() {
        player.currentItem?.removeObserver(self, forKeyPath: MusicPlayerManager.STATUS)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 播放完毕了
    ///
    /// - Parameter notification: <#notification description#>
    @objc func onComplete(notification:Notification) {
        delegate?.onComplete(data)
    }
    
    /// 停止进度更新
    func startPublishProgress() {
        if let _ = playTimeObserver {
            //已经启动
            print("已经开启了")
            return
        }
        
        //每秒钟更新一次
        playTimeObserver=player.addPeriodicTimeObserver(forInterval: CMTime(value: CMTimeValue(1), timescale: 1), queue: DispatchQueue.main, using: { (time) in
            //当前播放时间
            self.data.progress=Float(CMTimeGetSeconds(time))
            
            print("VideoPlayerManager startPublishProgress:\(self.data.progress)")
            
            guard let delegate = self.delegate else {
                //如果没有回调函数就停止定时器
                self.stopPublishProgress()
                return
            }
            
            //回调代理
            delegate.onProgress(self.data)
        })
        
    }
    
    /// 停止进度回调通知
    func stopPublishProgress() {
        if let playTimeObserver = playTimeObserver {
            player.removeTimeObserver(playTimeObserver)
            self.playTimeObserver=nil
            
        }
    }
    
    /// KVO方式监听回调
    ///
    /// - Parameters:
    ///   - keyPath: <#keyPath description#>
    ///   - object: <#object description#>
    ///   - change: <#change description#>
    ///   - context: <#context description#>
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("VideoPlayerManager observeValue:\(keyPath)")
        
        //判断监听的字段
        if keyPath == MusicPlayerManager.STATUS {
            //播放状态
            switch player.status {
            case .readyToPlay:
                //准备播放
                self.data.duration=Int(CMTimeGetSeconds(player.currentItem!.asset.duration))
                
                //回调代理
                delegate?.onPrepared(data)
            case .failed:
                //播放失败
                let error=player.error
                
                print("VideoPlayerManager play failed:\(error)")
                
                status = .error
                
                delegate?.onError(data, error)
            default:
                //未知状态
                print("VideoPlayerManager play unknown")
            }
            
        }
        
        
    }
    
}

/// 播放视频代理
//可以和播放音乐代理公用
protocol VideoPlayerDelegate: NSObjectProtocol {
    
    /// 进度回调
    ///
    /// - Parameter data: <#data description#>
    func onProgress(_ data:VideoDetailModel)
    
    /// 暂停了
    ///
    /// - Parameter data: <#data description#>
    func onPaused(_ data:VideoDetailModel)
    
    /// 正在播放
    ///
    /// - Parameter data: <#data description#>
    func onPlaying(_ data:VideoDetailModel)
    
    /// 播放器准备完毕
    ///
    /// - Parameter data: <#data description#>
    func onPrepared(_ data:VideoDetailModel)
    
    /// 播放失败了
    ///
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - error: <#error description#>
    func onError(_ data:VideoDetailModel,_ error:Error?)
    
    /// 播放完成了
    ///
    /// - Parameter data: <#data description#>
    func onComplete(_ data:VideoDetailModel)
}

