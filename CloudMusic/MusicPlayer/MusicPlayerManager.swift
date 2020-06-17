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
    
    /// 跳转时间
    var seekTime:Float?
    
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
            
            var dict = MPNowPlayingInfoCenter.default().nowPlayingInfo
            if dict != nil {
                
                //设置已经播放的时长
                dict![MPNowPlayingInfoPropertyElapsedPlaybackTime]=self.data.progress
                MPNowPlayingInfoCenter.default().nowPlayingInfo = dict
                
            }
            
//            //判断是否有代理
//            guard let delegate = self.delegate else {
//                //没有回调
//                //停止定时器
//                self.stopPublishProgress()
//                return
//            }
            let currentTime = CMTimeGetSeconds(self.player.currentItem?.currentTime() ?? CMTime())
            
            guard self.seekTime == nil else{
                let value = abs(Float(currentTime) - self.seekTime!)
                
                if value < 0.1{
                    self.seekTime = nil
                    //获取当前音乐播放时间
                    self.data!.progress = Float(currentTime)
                    //回调代理
                    self.delegate?.onProgress(self.data)
                }
                return
            }
            
            //获取当前音乐播放时间
            self.data!.progress = Float(currentTime)
            //回调代理
            self.delegate?.onProgress(self.data)
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
        
        //初始化设置
        initMedia()
        
        //如果不是同一首音乐
        if let currentData = self.data{
            //播放的不是同一首歌曲
            if (song.uri != currentData.uri) {
                delegate?.onSongChanged()
            }
        }
        
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
        
        seekTime = nil
        
        //回调代理
        delegate?.onPlaying(data!)
        
        //启动进度分发定时器
        startPublishProgress()
        
        //设置监听器
        //因为监听器是针对PlayerItem的
        //所以说播放了音乐在这里设置
        initListeners()
        
    }
    
    
    func updateMediaInfo(){
        //下载图片
        let manager = SDWebImageDownloader.shared

//        self.setMediaInfo()
        
        //获取图片地址
        guard let imageUrl = data.banner else { return }
        
        //下载图片
        manager.downloadImage(with: URL(string: imageUrl)) { (image, data, error, finished) in
            if let image = image {
                //图片下载完成
                self.setMediaInfo(image)
            }
        }

    }
    
    /// 设置媒体信息到系统的媒体控制中心
    ///
    /// - Parameter image: <#image description#>
    func setMediaInfo(_ image:UIImage? = nil) {
        //初始化一个可变字典
        var songInfo:[String:Any] = [:]
        
        var currentImage = image
        if currentImage == nil {
            currentImage = UIImage(named: "LoginLogo")
        }
        
        //初始化封面
        let albumArt = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100)) { size -> UIImage in
            return currentImage!
        }
        
        //设置封面
        songInfo[MPMediaItemPropertyArtwork]=albumArt
        
        //设置歌曲名称
        songInfo[MPMediaItemPropertyTitle] = data.title
        
        //歌手
        songInfo[MPMediaItemPropertyArtist]=data.singer.nickname
        
        //专辑名称
        //由于服务端没有返回专辑的数据
        //所以这里就写死数据就行了
        songInfo[MPMediaItemPropertyAlbumTitle]="这是专辑名称"
        
        //流派
        songInfo[MPMediaItemPropertyGenre]="这是流派"
        
        //设置音乐的总时长
        songInfo[MPMediaItemPropertyPlaybackDuration]=data.duration
        
        //设置已经播放的时长
        songInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime]=data.progress
        
        //设置歌词
        songInfo[MPMediaItemPropertyLyrics]="这是歌词"
        
        //设置到系统
        print("设置到系统")
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        
    }
    
    func initMedia(){
        //获取到音频会话
        let session = AVAudioSession.sharedInstance()
        
        //设置category
        //可以简单理解为：category就是预定好的一些模式
        //playback:可以后台播放；独占；音量可以控制音量
        try! session.setCategory(.playback, mode: .default, options: [])
        
        //激活音频会话
        try! session.setActive(true, options: [])
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
        seekTime = value
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
                
                //更新媒体控制中心信息
                updateMediaInfo()
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
    
    /// 切换了歌曲
    ///
    /// - Parameter data: 歌曲信息
    func onSongChanged()
}
