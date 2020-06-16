//
//  ZPSimpleMusicPlayerController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPSimpleMusicPlayerController: BaseViewController{
    
    ///列表
    @IBOutlet weak var tableView: UITableView!
    
    /// 标题
    @IBOutlet weak var lbTitle: UILabel!
    
    /// 当前播放时间
    @IBOutlet weak var lbStart: UILabel!
    
    /// 进度条
    @IBOutlet weak var sdProgress: UISlider!
    
    /// 音乐总时间
    @IBOutlet weak var lbEnd: UILabel!
    
    /// 播放按钮
    @IBOutlet weak var btPlay: UIButton!
    
    /// 循环模式
    @IBOutlet weak var btLoopModel: UIButton!
    
    var touchProgressHUDLabel: UILabel!
    
    /// 判断用户手点击了进度条
    var isSlideTouch = false
    
    /// 判断正在缓冲
    var isProgressIng = false
    
    /// 播放管理器
    var playListManager = PlayListManager.shared()
    
    var musicPlayerManager = MusicPlayerManager.shared()

    /// 初始化页面
    override func initViews() {
        
        super.initViews()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        label.text = "00:00"
        
        label.textColor = lbStart.textColor
        label.font = lbStart.font
        
        label.x = sdProgress.x
        label.y = sdProgress.convert(sdProgress.frame, to: self.view).origin.y
        self.view.addSubview(label)
        label.alpha = 0
        touchProgressHUDLabel = label
        
        showLoopMode()
        
        confirmCellClick()
    }
    
    /// 初始化数据
    override func initDatas(){

        
    }
}

extension ZPSimpleMusicPlayerController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("设置代理")
        musicPlayerManager.delegate = self
        
        if musicPlayerManager.isPlaying() {
            showPauseStatus()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        musicPlayerManager.delegate = nil
    }
}

extension ZPSimpleMusicPlayerController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playListManager.getPlayList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")
        
        let song = playListManager.getPlayList()[indexPath.row]
        
        cell?.textLabel?.text = song.title
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let song = playListManager.getPlayList()[indexPath.row]

        playListManager.musicPlayerManager.play(song)
    }
}

// MARK: - 获取信息后 布局页面
extension ZPSimpleMusicPlayerController {
    
    func confirmCellClick(){
        
        let arr = playListManager.datum as NSArray
        
        let index = arr.index(of: playListManager.data!)
        
        let indexPath = IndexPath(row: index, section: 0)
        
        tableView(tableView, didSelectRowAt: indexPath)
        
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }
    
    /// 显示初始化音乐数据
    func showInitData() {
        let data = playListManager.data
        
        //显示标题
        lbTitle.text = data?.title
        
        let time:Float = data?.progress ?? 0
        
        sdProgress.value = time
        lbStart.text = TimeUtil.second2MinuteAndSecond(time)
    }
    
    /// 显示播放总时长
    func showDuration() {
        if let duration = playListManager.data?.duration {
            if duration > 0 {
                lbEnd.text = TimeUtil.second2MinuteAndSecond(duration)
                sdProgress.maximumValue = duration
            }
        }
    }
    
    /// 显示进度
    func showProgress() {
        let progress = playListManager.data!.progress
        
        if progress > 0 {
            
            if !isSlideTouch {
                
                lbStart.text = TimeUtil.second2MinuteAndSecond(progress)
                
                if !isProgressIng{
                    sdProgress.value = progress
                }else{
                    print("正在缓冲 不更新progress位置")
                }
            }else{
                print("正在拖拽 不更新进度条")
            }
        }
    }
    
    /// 显示播放状态
    func showPlayStatus()  {
        btPlay.setTitle("播放", for: .normal)
    }
    
    /// 显示暂停状态
    func showPauseStatus() {
        print("设置为暂停状态")
        btPlay.setTitle("暂停", for: .normal)
    }
    
    /// 展示循环模式
    func showLoopMode(){
        //获取当前循环模式
        let mode = playListManager.getLoopModel()
        
        switch mode {
        case .list:
            btLoopModel.setTitle("列表循环", for: .normal)
        case .random:
            btLoopModel.setTitle("随机循环", for: .normal)
        default:
            btLoopModel.setTitle("单曲循环", for: .normal)
        }
    }
}

// MARK: - 播放相关的方法
extension ZPSimpleMusicPlayerController {
    
    // MARK: - 进度条相关
        
    /// 进度条拖拽回调
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onProgressChanged(_ sender: UISlider) {
        //将拖拽进度显示到界面
        //用户就很方便的知道自己拖拽到什么位置
        touchProgressHUDLabel.text = TimeUtil.second2MinuteAndSecond(sender.value)
        
        
        touchProgressHUDLabel.centerX = 15 + sdProgress.x + CGFloat(sdProgress.value/sdProgress.maximumValue) * (sdProgress.width - 30)
        
    }
        
    /// 进度条按下
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onSlideTouchDown(_ sender: UISlider) {
        print("SimplePlayerController onSlideTouchDown")
            
        isSlideTouch=true
        
        UIView.animate(withDuration: 0.3) {
            self.touchProgressHUDLabel.alpha = 1
        }
        
    }
        
    /// 进度条抬起
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onTouchUpInsideSlide(_ sender: UISlider) {
        
        print("SimplePlayerController onSlideTouchUpInside")
            
        isSlideTouch = false
            
        playListManager.seekTo(sender.value)
        
        UIView.animate(withDuration: 0.3) {
            self.touchProgressHUDLabel.alpha = 0
        }
    }
    
    @IBAction func onTouchUpOutsideSlide(_ sender: Any) {
        isSlideTouch = false
        
        UIView.animate(withDuration: 0.3) {
            self.touchProgressHUDLabel.alpha = 0
        }
    }
    
    /// 上一曲
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onPreviousClick(_ sender: Any) {
        print("SimplePlayerController onPreviousClick")
        
        playListManager.play(playListManager.previous())
        
        confirmCellClick()
        
        showInitData()
    }
    
    /// 播放按钮
    ///
    /// - Parameter sender: 按钮
    @IBAction func onPlayClick(_ sender: Any) {
        print("SimplePlayerController onPlayClick")
        
        playOrPause()
    }
    
    
    /// 下一曲
    ///
    /// - Parameter sender: 按钮
    @IBAction func onNextClick(_ sender: Any) {
        print("SimplePlayerController onNextClick")
        
        playListManager.play(playListManager.next())
        
        confirmCellClick()
        
        showInitData()
    }
    
    /// 循环模式
    ///
    /// - Parameter sender: 按钮
    @IBAction func onLoopModelClick(_ sender: Any) {
        print("SimplePlayerController onLoopModelClick")
        let _ = playListManager.changeLoopMode()
        showLoopMode()
    }
    
    func playOrPause(){
        playListManager.playOrPause()
    }
}

extension ZPSimpleMusicPlayerController:MusicPlayerDelegate{
    
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
        showInitData()
        
        showDuration()
    }
    
    /// 暂停了
    func onPaused(_ data: Song) {
        showPlayStatus()
    }
    
    /// 播放中
    func onPlaying(_ data: Song) {
        showPauseStatus()
    }
    
    /// 进度回调
    func onProgress(_ data: Song) {
        print("进度回调了 更新进度")
        showProgress()
    }
    
    func onComplete(_ data: Song) {
        
        //获取当前循环模式
        let model = playListManager.getLoopModel()
        
        switch model {
        case .one:
            playListManager.play(playListManager.data!)
        default:
            playListManager.play(playListManager.next())
            confirmCellClick()
        }
        
    }
}

// MARK: - 启动界面
extension ZPSimpleMusicPlayerController {
    
    /// 启动界面
    ///
    /// - Parameter navigationController: <#navigationController description#>
    static func start(_ navigationController:UINavigationController) {
        //创建控制器
        let controller = ZPSimpleMusicPlayerController()
        
        //将控制器压入导航控制器
        navigationController.pushViewController(controller, animated: true)
    }
}
