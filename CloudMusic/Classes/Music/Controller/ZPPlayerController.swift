//
//  ZPPlayerController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/18.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

import GKCover

import SwiftEventBus

class ZPPlayerController: BaseViewController {

    // MARK: - 背景
    
    /// 黑胶唱片背景
    @IBOutlet weak var recordBackgroundBorder: UIImageView!
    
    /// 封面背景
    @IBOutlet weak var ivBackground: UIImageView!
    
    /// 封面备份 用于图片替换
    @IBOutlet weak var ivBackground2: UIImageView!
    
    // MARK: -  黑胶唱片CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// 唱片指针
    @IBOutlet weak var recordThumb: UIImageView!
    
    // MARK: - 迷你控制栏
    
    /// 喜欢按钮
    @IBOutlet weak var btLike: UIButton!
    
    /// 下载按钮
    @IBOutlet weak var btDownload: ZPPlayerDownloadButton!
    
    /// 均衡器按钮
    @IBOutlet weak var btEqualizer: UIButton!
    
    /// 评论按钮
    @IBOutlet weak var btComment: UIButton!
    
    /// 更多按钮
    @IBOutlet weak var btMore: UIButton!
    
    // MARK: - 进度相关
    
    /// 播放时间
    @IBOutlet weak var lbStart: UILabel!
    
    /// 进度条
    @IBOutlet weak var sdProgress: UISlider!
    
    /// 音乐总时间
    @IBOutlet weak var lbEnd: UILabel!
    
    // MARK: - 控制按钮
    
    /// 循环模式
    @IBOutlet weak var btLoopModel: UIButton!
    
    /// 上一曲
    @IBOutlet weak var btPrevious: UIButton!
    
    /// 播放按钮
    @IBOutlet weak var btPlay: UIButton!
    
    /// 下一曲
    @IBOutlet weak var btNext: UIButton!
    
    /// 播放列表
    @IBOutlet weak var btList: UIButton!
    
    /// 第一次拖动屏幕
    var isFirstScroll = true
    
    /// 正在读取数据
    var isProgressIng = false

    /// 判断用户手点击了进度条
    var isSlideTouch = false
    
    /// 播放列表管理器
    var playListManager = PlayListManager.shared()
    
    /// 播放管理器
    var musicPlayerManager = MusicPlayerManager.shared()
    
    /// 歌词管理器
    var lyricView:ZPPlayerLyricView!
    
    override func initViews() {
        
        super.initViews()
        
        //进度条
        //设置进度条颜色
        sdProgress.minimumTrackTintColor = UIColor(hexColor: COLOR_PRIMARY)
        
        //设置拖动点颜色
        sdProgress.thumbTintColor = UIColor(hexColor: COLOR_PRIMARY)
        
        self.collectionView.register(UINib(nibName: "ZPSongRecordCell", bundle: nil), forCellWithReuseIdentifier: "SongRecordCell")
        
        //设置recordThumb的锚点
        DispatchQueue.main.async {
            
            self.recordThumb.x = ZScreenWidth/2.0 - 15
            self.recordThumb.y = 20
            
            self.recordThumb.setViewAnchorPoint(CGPoint(x:0.181,y:0.12))
            self.recordThumb.transform=CGAffineTransform(rotationAngle: -0.4363323)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecordView))
        
        self.collectionView.addGestureRecognizer(tap)
        
        lyricView = ZPPlayerLyricView.loadViewFromNib()
        
        lyricView.lrcUrl = playListManager.data?.lrcUrl
        
        view.addSubview(lyricView)
        
        lyricView.isHidden = true
        
        let tapLyric = UITapGestureRecognizer(target: self, action: #selector(tapLyricView))
        
        lyricView.addGestureRecognizer(tapLyric)
        
        lyricView.onClickDragPlayBlock = { [weak self] progress in
            guard let `self` = self else { return }
            
            self.sdProgress.value = Float(progress)
            self.onPorgressTouchUpInside(self.sdProgress)
        }
        
        print("初始化视图")
        initPlayData()
        
        //collectionView长按事件
        let collectionViewLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onCollectionViewLongClick(gesture:)))
        
        //设置最小按下时间
        collectionViewLongPressGestureRecognizer.minimumPressDuration = 1.0
        collectionView.addGestureRecognizer(collectionViewLongPressGestureRecognizer)
        
        //歌词长按
        let onLyricLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLyricLongClick(gesture:)))
        onLyricLongPressGestureRecognizer.minimumPressDuration = 1.0
        
        lyricView.addGestureRecognizer(onLyricLongPressGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lyricView.frame = CGRect(x: 0, y: ZNaviationHeight, width: ZScreenWidth, height: collectionView.height)
        
    }

    override func initListener() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    //MARK: - 界面上的按钮点击事件
    
    // MARK: - 进度相关
    
    /// 当进度条拖拽时
    ///
    /// - Parameter sender:progress
    @IBAction func onPorgressTouchUpInside(_ sender: UISlider) {
        print("PlayerController onProgressChanged:\(sender.value)")
        isSlideTouch = false
        playListManager.seekTo(sender.value)
    }
    
    
    @IBAction func onProgressTouchDown(_ sender: Any) {
        isSlideTouch = true
    }
    
    @IBAction func onProgressTouchUp(_ sender: Any) {
        isSlideTouch = false
    }
    
    
    // MARK: - 控制栏
    
    /// 循环模式点击
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onLoopModelClick(_ sender: Any) {
        print("PlayerController onLoopModelClick")
        
        let _ = playListManager.changeLoopMode()
        
        //显示循环模式
        showLoopModel()
    }
    
    func showLoopModel(){
        //获取当前循环模式
        let model = playListManager.getLoopModel()
        
        switch model {
        case .list:
            //列表循环
            btLoopModel.setImage(UIImage(named: "MusicRepeatList"), for: .normal)
        case .random:
            //随机循环
            btLoopModel.setImage(UIImage(named: "MusicRepeatRandom"), for: .normal)
        default:
            //单曲循环
            btLoopModel.setImage(UIImage(named: "MusicRepeatOne"), for: .normal)
        }
    }
    
    /// 上一曲
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onPreviousClick(_ sender: Any) {
        print("PlayerController onPreviousClick")
        
        stopReocrdRotate()
        
        playListManager.play(playListManager.previous())
    }
    
    
    /// 播放
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onPlayClick(_ sender: Any) {
        print("PlayerController onPlayClick")
        
        playOrPause()
    }
    
    func playOrPause(){
        if musicPlayerManager.isPlaying() {
            playListManager.pause()
        } else {
            playListManager.resume()
        }
    }
    
    /// 下一曲
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onNextClick(_ sender: Any) {
        print("PlayerController onNextClick")
        
        stopReocrdRotate()
        
        playListManager.play(playListManager.next())
    }
    
    
    /// 播放列表点击
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onListClick(_ sender: Any) {
        print("PlayerController onListClick")
        
        //创建一个View
        let musicPlayListView = MusicPlayListView.loadViewFromNib()

        //设置尺寸
        musicPlayListView.gk_size = CGSize(width: view.frame.width, height: view.frame.height/1.5)

        //设置点击音乐回调
        musicPlayListView.onSongClick = {
            data in
            self.stopReocrdRotate()

            self.playListManager.play(data)
        }

        //显示这个View
        GKCover.translucentCover(from: view, content: musicPlayListView, animated: true)
    }
    
    static func start(_ navigationController:UINavigationController){
        let controller = ZPPlayerController()
        navigationController.pushViewController(controller, animated: true)
    }
    
    ///点击了黑胶唱片
    @objc func tapRecordView(){
        
        print("PlayerController tapRecordView")
        
        //显示歌词控件
        lyricView.isHidden = false
        
        //使用动画
        UIView.animate(withDuration: 0.5, animations: {
            //动画执行的逻辑
            
            //将歌词控件透明度改为1
            self.lyricView.alpha=1.0
            
            //将黑胶唱片相关控件透明度改为0
            self.collectionView.alpha=0
            self.recordBackgroundBorder.alpha=0
            self.recordThumb.alpha=0
            
        }) { finished in
            //动画执行完成后
            
            //将黑胶唱片完全隐藏
            self.collectionView.isHidden = true
            self.recordThumb.isHidden = true
            self.recordBackgroundBorder.isHidden = true
        }
        
    }
    
    /// 点击了歌词
    @objc func tapLyricView(){
        
        print("PlayerController tapLyricView")
         
         //显示出黑胶唱片相关功能
         collectionView.isHidden=false
         recordBackgroundBorder.isHidden=false
         recordThumb.isHidden=false
         
         //使用动画
         UIView.animate(withDuration: 0.5, animations: {
             //动画执行的逻辑
             
             //将黑胶唱片相关控件透明度设置为1
             self.collectionView.alpha=1
             self.recordBackgroundBorder.alpha=1
             self.recordThumb.alpha=1
             
             //将歌词控件透明度设置0
             self.lyricView.alpha=0
             
         }) { finished in
             //动画执行完成后的逻辑
             
             //将歌词控件完全隐藏
             self.lyricView.isHidden=true
         }
        
    }
    
    /// 歌词长按事件回调
    ///
    /// - Parameter gesture: <#gesture description#>
    @objc func onLyricLongClick(gesture:UILongPressGestureRecognizer) {
        //会调用多次
        //通过如下代码过滤掉多次
        if gesture.state != .began {
            return
        }
        
        print("PlayerController onLyricLongClick")
        
        if let lyricUrl = playListManager.data?.lrcUrl {
            
            let path = Bundle.main.path(forResource: lyricUrl, ofType: "lrc")
            let lrcString = try! String(contentsOfFile: path!, encoding: .utf8)
            let lyric = LyricParser.parse(.lrc, lrcString)
            
            //启动歌词选择界面
            SelectLyricController.start(navigationController!, playListManager.data!, lyric)
        }
        
    }
    
    /// 封面长按事件
    ///
    /// - Parameter gusture: <#gusture description#>
    @objc func onCollectionViewLongClick(gesture:UILongPressGestureRecognizer) {
        //会调用多次
        //通过如下代码过滤掉多次
        if gesture.state != UIGestureRecognizer.State.began {
            return
        }
        
        print("PlayerController onCollectionViewLongClick")
        
        //启动图片预览界面
        ImagePreviewController.start(navigationController!, playListManager.data!.banner)
    }
    
    deinit {
        print("将要销毁了")
        
        stopReocrdRotate()
    }
}

// MARK: - 获取信息后 布局页面
extension ZPPlayerController{
    
    func initPlayData(){
        
        lyricView.lrcUrl = playListManager.data?.lrcUrl
        
        //显示初始化数据
        showMusicData()
        
        //显示播放状态
        showMusicPlayStatus()
        
        //展示时长
        showDuration()
        
        //展示进度
        showProgress()
        
        //确认下载按钮的状态
        btDownload.songChanged()
    }
    
    func showMusicData(){
        let data = playListManager.data
        
        //显示标题
        setTitle("\(data!.title!) - \(data!.singer.nickname!)")
        
        self.ivBackground.alpha = 1
        self.ivBackground2.alpha = 0
        
        let url = URL(string: data?.banner ?? "")
        
        UIView.animate(withDuration: 0.3, animations: {
            self.ivBackground.alpha = 0
            self.ivBackground2.alpha = 1
            self.ivBackground2.sd_setImage(with: url, completed: nil)
            
        }) { (animation) in
            self.ivBackground.sd_setImage(with: url, completed: nil)
            self.ivBackground.alpha = 1
        }
    }
    
    func showMusicPlayStatus(){
        if musicPlayerManager.isPlaying() {
            showPauseStatus()
        } else {
            showPlayStatus()
        }
    }
    
    /// 显示播放状态
    func showPlayStatus() {
        btPlay.setImage(UIImage(named: "MusicPlay"), for: .normal)
    }
    
    /// 显示暂停状态
    func showPauseStatus() {
        btPlay.setImage(UIImage(named: "MusicPause"), for: .normal)
    }
    
    func showProgress(){
        let progress = playListManager.data!.progress
        
            if !isSlideTouch {
                
                lbStart.text = TimeUtil.second2MinuteAndSecond(progress)
                
                if !isProgressIng{
//                    print("更新progress位置")
                    sdProgress?.value = progress
                    
                    lyricView.progress = progress
                    
                }else{
                    print("正在缓冲 不更新progress位置")
                }
            }else{
                print("正在拖拽 不更新进度条")
            }
        
    }
    
    func showDuration(){
        //获取当前音乐总时长
        let duration = musicPlayerManager.data.duration
        
        if duration >= 0 {
            //格式化后显示文本
            lbEnd.text = TimeUtil.second2MinuteAndSecond(duration)
            
            //设置到进度条
            sdProgress.maximumValue = duration
        }
    }
}

extension ZPPlayerController: MusicPlayerDelegate{
    /// 播放器正在缓冲
    func onLoading(_ data: Song) {
        print("正在缓冲")
        isProgressIng = true
    }
    
    /// 播放器缓冲完毕
    func onLoadingSuccess(_ data: Song) {
        print("结束缓冲")
        isProgressIng = false
    }
    
    /// 播放器准备完毕了
    func onPrepared(_ data: Song) {
        print("SimplePlayController onPrepared duration:\(data.duration)")
        showDuration()
    }
    
    /// 暂停了
    func onPaused(_ data: Song) {
        showPlayStatus()
        
        stopReocrdRotate()
    }
    
    /// 播放中
    func onPlaying(_ data: Song) {
        showPauseStatus()
        
        startRecordRotate()
    }
    
    /// 进度回调
    func onProgress(_ data: Song) {

        print("回调的时间是\(data.progress)")
        
        showProgress()
    }
    
    func onComplete(_ data: Song) {
        
        print("播放完了 根据模式切换下一曲")
        playListManager.play(playListManager.next())
        confirmCellClick()
        
    }
    
    /// 切换了歌曲 重新设置展示信息
    func onSongChanged() {
        
        print("歌曲改变了/或者前后台切换了 重新设置页面的属性")

        initPlayData()
        
        confirmCellClick()
    }
    
    func confirmCellClick(_ animated: Bool = true){
        //获取到播放列表
        let playListOC = playListManager.getPlayList() as! NSArray
        
        //获取当前音乐在播放列表中的位置
        let index = playListOC.index(of: playListManager.data!)
        
        print("index is \(index)")
        
        //创建IndexPath
        let indexPath = IndexPath(item: index, section: 0)
        
        var currentAnimated = animated
        
        DispatchQueue.main.async {

            //获取滚动后的index
            let currentIndex = self.getCurrentIndex()
            
            if abs(index - currentIndex) > 1{
                currentAnimated = false
            }
            
            //滚动到当前黑胶唱片
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: currentAnimated)
            
            if self.musicPlayerManager.isPlaying(){
                print("正在播放中 开始旋转")
                
                DispatchQueue.main.async {
                    self.startRecordRotate()
                }
            }
            
            

        }
    }
    
    func confirmCellClickNoAnimate(){
        confirmCellClick(false)
    }
}

extension ZPPlayerController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playListManager.getPlayList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //取出数据
        let data = playListManager.getPlayList()[indexPath.row]
        
        //获取Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongRecordCell", for: indexPath) as! ZPSongRecordCell
        
        //设置Tag
        cell.tag = indexPath.row
        
        //绑定数据
        cell.bindData(data)
        
        //返回cell
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        isFirstScroll = true
        
        //获取滚动后的index
        let currentIndex = getCurrentIndex()
        
        //获取滚动后的音乐
        let currentData = playListManager.getPlayList()[currentIndex]
        
        //获取正在播放的这首音乐
        let data = playListManager.data!
        
        //判断滚动后的音乐是否是正在播放的音乐
        if data.id == currentData.id {
            //同一首音乐
            
            if musicPlayerManager.isPlaying() {
                //如果当前音乐在播放
                //就开始滚动黑胶唱片
                startRecordRotate()
            }
        } else {
            //不是同一首音乐
            //播放滚动后的这首音乐
            playListManager.play(currentData)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if isFirstScroll {
            //停止黑胶唱片滚动
            stopReocrdRotate()

            isFirstScroll = false
        }
    }
    
    /// 获取当前位置的IndexPath
    ///
    /// - Returns: <#return value description#>
    func getCurrentIndex() -> Int {
       let indexPath = collectionView.indexPathForItem(at: collectionView.contentOffset)!
        
        print("PlayerController getCurrentIndex:\(indexPath.row)")
        
        return indexPath.row
    }
}

// MARK: - 控制唱片的滚动 和指针的位置
extension ZPPlayerController{
    /// 黑胶唱片开始滚动
     /// 指针回到播放位置(默认)
     func startRecordRotate()  {
         //选择黑胶唱片指针
         startRecordThumbRotate()

         //获取当前音乐
         let data = playListManager.data!
         //发送事件
         SwiftEventBus.post(ON_START_RECORD, sender: data)
     }
     
     /// 黑胶唱片停止滚动
     /// 指针回到暂停状态(-25度)
     func stopReocrdRotate() {
         print("PlayerController stopRecordRotate")
         
         //停止黑胶唱片指针
         stopRecordThumbRotate()
         
         //获取当前音乐
         let data = playListManager.data!
         
         //发送事件
         SwiftEventBus.post(ON_STOP_RECORD, sender: data)
     }
     
         // MARK: - 唱片指针相关方法
     
     /// 黑胶唱片指针默认状态（播放状态）
     func startRecordThumbRotate() {
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut , animations: {
            self.recordThumb.transform = CGAffineTransform.identity
        }, completion: nil)

     }
     
     /// 黑胶唱片指针旋转-25度（暂停状态）
     func stopRecordThumbRotate() {
        self.recordThumb.transform=CGAffineTransform.identity
        print("黑胶唱片指针旋转-25度（暂停状态）")
        UIView.animate(withDuration: 0.5) {
            
            if self.recordThumb.transform == .identity{
                self.recordThumb.transform=CGAffineTransform(rotationAngle: -0.4363323)
            }
        }
     }
}

// MARK: - 实现UICollectionViewDelegateFlowLayout协议
extension ZPPlayerController: UICollectionViewDelegateFlowLayout {
    
    /// 返回Cell和CollectionView的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    /// 返回每一行Cell间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /// 返回每列Cell间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    /// 返回Cell大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //让Cell和Collection一样大
        return collectionView.frame.size
    }
}

//MARK: - 生命周期相关
extension ZPPlayerController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTitleBarLight()
        
        musicPlayerManager.delegate = self

        DispatchQueue.main.async {
            self.confirmCellClickNoAnimate()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        musicPlayerManager.delegate = nil
    }
    
    @objc func onEnterForeground(){
        initPlayData()
        confirmCellClickNoAnimate()
    }

}
