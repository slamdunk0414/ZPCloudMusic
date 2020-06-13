//
//  ZPSimpleMusicPlayerController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/13.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPSimpleMusicPlayerController: BaseViewController{

    /// 音乐播放列表
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
    
    /// 播放管理器
    var musicPlayerManager:MusicPlayerManager!
    
    /// 播放列表
    var songs:[Song]?
    
    var currentSong:Song?
    
    /// 初始化页面
    override func initViews() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    /// 初始化数据
    override func initDatas(){
        
        //测试音乐数据
        let songUrl = "http://freetyst.nf.migu.cn/public/product4th/product36/2019/09/0623/2018%E5%B9%B409%E6%9C%8823%E6%97%A513%E7%82%B925%E5%88%86%E6%89%B9%E9%87%8F%E9%A1%B9%E7%9B%AE%E5%8D%8E%E7%BA%B343%E9%A6%96-15/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005751F94D.mp3"

        let song = Song()
        song.uri = songUrl
        song.title = "逆光 -- 孙燕姿"
        
        currentSong = song
        
        let songUrl2 = "http://freetyst.nf.migu.cn/public/product8th/product40/2020/06/0300/2020%E5%B9%B406%E6%9C%8802%E6%97%A519%E7%82%B904%E5%88%86%E7%B4%A7%E6%80%A5%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5%E5%8D%8E%E7%BA%B31%E9%A6%96275504/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005752GQ4A003947.mp3"

        let song2 = Song()
        song2.uri = songUrl2
        song2.title = "开始懂了 -- 孙燕姿"
        
        let songUrl3 = "http://freetyst.nf.migu.cn/public/product9th/product41/2020/06/1018/2020%E5%B9%B406%E6%9C%8810%E6%97%A507%E7%82%B913%E5%88%86%E7%B4%A7%E6%80%A5%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5%E5%8D%8E%E7%BA%B319%E9%A6%96800531/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005752HBA8180907.mp3"

        let song3 = Song()
        song3.uri = songUrl3
        song3.title = "遇见 -- 孙燕姿"
        
        songs = [song,song2,song3]
        
        musicPlayerManager = MusicPlayerManager.shared()
        musicPlayerManager.delegate = self
        musicPlayerManager.play(song)
    }
}

extension ZPSimpleMusicPlayerController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")
        
        let song = songs?[indexPath.row]
        
        cell?.textLabel?.text = song?.title
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let song = songs?[indexPath.row] else { return}
        
        musicPlayerManager.play(song)
    }
}

// MARK: - 获取信息后 布局页面
extension ZPSimpleMusicPlayerController {
    /// 显示初始化音乐数据
    func showInitData() {
        let data = currentSong
        
        //显示标题
        lbTitle.text = data?.title
    }
    
    /// 显示播放总时长
    func showDuration() {
        if let duration = currentSong?.duration {
            if duration > 0 {
                lbEnd.text = TimeUtil.second2MinuteAndSecond(duration)
                sdProgress.maximumValue = duration
            }
        }
    }
    
    /// 显示进度
    func showProgress() {
        let progress = musicPlayerManager.data!.progress
        
        if progress > 0 {
            lbStart.text = TimeUtil.second2MinuteAndSecond(progress)
            sdProgress.value = progress
        }
    }
    
    /// 显示播放状态
    func showPlayStatus()  {
        btPlay.setTitle("播放", for: .normal)
    }
    
    /// 显示暂停状态
    func showPauseStatus() {
        btPlay.setTitle("暂停", for: .normal)
    }
    
}

// MARK: - 播放相关的方法
extension ZPSimpleMusicPlayerController {
    
    /// 上一曲
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onPreviousClick(_ sender: Any) {
        print("SimplePlayerController onPreviousClick")
        
    }
    
    
    /// 播放按钮
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onPlayClick(_ sender: Any) {
        print("SimplePlayerController onPlayClick")
        
        playOrPause()
    }
    
    
    /// 下一曲
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onNextClick(_ sender: Any) {
        print("SimplePlayerController onNextClick")
    }
    
    /// 循环模式
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onLoopModelClick(_ sender: Any) {
        print("SimplePlayerController onLoopModelClick")
    }
    
    func playOrPause(){
        if musicPlayerManager.isPlaying() {
            musicPlayerManager.pause()
        } else {
            musicPlayerManager.resume()
        }
    }
}

extension ZPSimpleMusicPlayerController:MusicPlayerDelegate{
    
    /// 播放器正在缓冲
    func onLoading(_ data: Song) {
        
    }
    
    /// 播放器缓冲完毕
    func onLoadingSuccess(_ data: Song) {
        
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
        print("SimplePlayerController onProgress:\(data.progress),\(data.duration)")
        showProgress()
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
