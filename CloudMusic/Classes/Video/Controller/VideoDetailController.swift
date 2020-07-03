//
//  VideoDetailController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/7/2.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

//导入媒体播放框架
import MediaPlayer

class VideoDetailController: BaseViewController{

    var videoView: UIView!
    
    var videoModel:VideoDetailModel!
    
    /// 视频播放管理器
    var videoPlayerManager:VideoPlayerManager = VideoPlayerManager.shared()
    
    /// 显示视频画面的控件
    var playLayer:AVPlayerLayer!
    
    var canAutorotate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func initViews() {
        
        super.initViews()
        
        videoView = UIView(frame: CGRect(x: 0, y: 0, width: ZScreenWidth, height: 0))
        videoView.height = videoView.width * 9 / 16 + SafeFrameUtil.getSafeAreaTop()
        videoView.backgroundColor = .blue
        
        view.addSubview(videoView)
        
        //显示视频画面的layer
        playLayer = videoPlayerManager.playerLayer
        
        //把layer添加到界面
        videoView.layer.insertSublayer(playLayer, at: 0)
        
        //设置播放代理
        videoPlayerManager.delegate=self
    }
    
    override func initDatas() {
        
        play()
        
    }
    
    func play() {
        //播放在线视频
        videoPlayerManager.play(self.videoModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //重新设置layer尺寸和位置
        playLayer.frame = videoView.bounds
        
        print("VideoDetailController viewDidLayoutSubViews:\(videoView.bounds)")
    }
    
    override func initListener() {
        super.initListener()
        
        print("监听屏幕方向")
        
        //开启监听设备屏幕方向
        //如果不开启就监听不到
        if !UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        
        //注册屏幕方向改变通知
        NotificationCenter.default.addObserver(self, selector: #selector(onDeviceOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        
//        //监听进入后台
//        NotificationCenter.default.addObserver(self, selector: #selector(onEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
//        
//        //监听进入后台
//        NotificationCenter.default.addObserver(self, selector: #selector(onEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    // MARK: - 屏幕方向
    
    /// 屏幕方向改变了调用
    ///
    /// - Parameter notification: <#notification description#>
    @objc func onDeviceOrientationChanged() {
        //获取当前屏幕方向
        let deviceOrientation = UIDevice.current.orientation
        
        switch deviceOrientation {
        case .landscapeLeft:
            print("屏幕向左横置")
            onDeviceOrientationLandscape()
        case .landscapeRight:
            print("屏幕向右横置")
            onDeviceOrientationLandscape()
        case .portrait:
            print("屏幕直立")
            onDeviceOrientationPortrait()
        default:
            break
        }
    }
    
    /// 横屏
    func onDeviceOrientationLandscape() {
        videoView.y = 0
        videoView.x = 0
        //视频容器的高度为视频高度
        
        print("width is \(ZScreenWidth) height is \(ZScreenHeight)")
        
        videoView.width = ZScreenHeight
        videoView.height = ZScreenWidth
        
    }
    
    /// 竖屏
    func onDeviceOrientationPortrait() {
        //如果是竖屏 则加大高度

        videoView.y = 0
        videoView.x = 0

        //视频容器的高度为视频高度
        videoView.width = ZScreenWidth
        videoView.height = videoView.width * 9 / 16 + SafeFrameUtil.getSafeAreaTop()

    }
    
    /// 设置屏幕方向
    ///
    /// - Parameter data: <#data description#>
    func setOrientation(_ data:UIDeviceOrientation) {
        print("设置屏幕方向")
        UIDevice.current.setValue(data.rawValue, forKey: "orientation")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTitleBarLight()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        canAutorotate = true
        
        let deviceOrientation = UIDevice.current.orientation
        
        self.setOrientation(deviceOrientation)
        
        UIViewController.attemptRotationToDeviceOrientation()
        
        onDeviceOrientationChanged()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        videoPlayerManager.pause()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        canAutorotate = false
        
        setTitleBarDefault()
    }

}

extension VideoDetailController : VideoPlayerDelegate{
    func onProgress(_ data: VideoDetailModel) {
        
    }
    
    func onPaused(_ data: VideoDetailModel) {
        
    }
    
    func onPlaying(_ data: VideoDetailModel) {
        
    }
    
    func onPrepared(_ data: VideoDetailModel) {
        
    }
    
    func onError(_ data: VideoDetailModel, _ error: Error?) {
        
    }
    
    func onComplete(_ data: VideoDetailModel) {
        
    }
}

extension VideoDetailController : UIGestureRecognizerDelegate {
    
}

extension VideoDetailController{
    
    open override var shouldAutorotate: Bool {
        return canAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        let orientation = (UIInterfaceOrientation(rawValue: UIInterfaceOrientation.portrait.rawValue | UIInterfaceOrientation.landscapeLeft.rawValue | UIInterfaceOrientation.landscapeRight.rawValue)!) as UIInterfaceOrientation
        
        return orientation
    }
    
}
