//
//  ZPHomeViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/4.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPHomeViewController: BaseViewController {

    @IBOutlet weak var replayButton: UIButton!
    
    override func initViews() {
        
        self.view.backgroundColor = .white

        replayButton.addTarget(self, action:#selector(pushToSimpleController), for: .touchUpInside)
        
        //去掉导航栏下面的阴影
        //这个导航栏有层次感
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //导航栏透明
        //这里设置导航透明后
        //就没有上面的灰色了
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        confirmLocalData()
    }
    
    func confirmLocalData(){
        
        if PlayListManager.shared().getPlayList().count > 0 {
            replayButton.setTitle("有数据 可以恢复播放", for: .normal)
            replayButton.isEnabled = true
        }else{
            replayButton.setTitle("无数据 不可恢复播放", for: .normal)
            replayButton.isEnabled = false
        }

    }
    
    @IBAction func clickYanZiPlayer(_ sender: Any) {
        setYanziList()
        pushToPlayerController()
    }
    
    
    @IBAction func clickJacksonPlayer(_ sender: Any) {
        setJacksonList()
        pushToPlayerController()
    }
    
    //点击了孙燕姿
    @IBAction func clickYanZiSimple(){

        setYanziList()
        
        pushToSimpleController()
    }
    
    @IBAction func clickMemory(_ sender: Any) {
        setSingle()
        pushToPlayerController()
    }
    
    @IBAction func clickJacksonSimple(){
        
        setJacksonList()

        pushToSimpleController()
        
    }
    
    @objc func pushToPlayerController(){
        ZPPlayerController.start(self.navigationController!)
    }
    
    @objc func pushToSimpleController() {
        ZPSimpleMusicPlayerController.start(self.navigationController!)
    }
    
}

//设置播放列表
extension ZPHomeViewController{
    
    func setYanziList(){
        //测试音乐数据
        let songUrl = "http://freetyst.nf.migu.cn/public/product4th/product36/2019/09/0623/2018%E5%B9%B409%E6%9C%8823%E6%97%A513%E7%82%B925%E5%88%86%E6%89%B9%E9%87%8F%E9%A1%B9%E7%9B%AE%E5%8D%8E%E7%BA%B343%E9%A6%96-15/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005751F94D.mp3"
        let song = Song()
        song.id = "1"
        song.uri = songUrl
        song.lrcUrl = "逆光"
        song.title = "逆光"
        song.banner = "http://cdnmusic.migu.cn/picture/2019/1029/1507/AL53a8b2cdf90a44449bbf554ecd85b331.jpg"
        
        let songUrl2 = "http://freetyst.nf.migu.cn/public/product8th/product40/2020/06/0300/2020%E5%B9%B406%E6%9C%8802%E6%97%A519%E7%82%B904%E5%88%86%E7%B4%A7%E6%80%A5%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5%E5%8D%8E%E7%BA%B31%E9%A6%96275504/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005752GQ4A003947.mp3"
        let song2 = Song()
        song2.id = "2"
        song2.uri = songUrl2
        song2.title = "开始懂了"
        song2.lrcUrl = "开始懂了"
        song2.banner = "http://cdnmusic.migu.cn/picture/2020/0324/0007/AL94526fc9e31d7dd0d87ec946ae6ed6d0.jpg"
        let songUrl3 = "http://freetyst.nf.migu.cn/public/product9th/product41/2020/06/1018/2020%E5%B9%B406%E6%9C%8810%E6%97%A507%E7%82%B913%E5%88%86%E7%B4%A7%E6%80%A5%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5%E5%8D%8E%E7%BA%B319%E9%A6%96800531/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005752HBA8180907.mp3"

        let song3 = Song()
        song3.uri = songUrl3
        song3.id = "3"
        song3.title = "遇见"
        song3.lrcUrl = "遇见"
        song3.banner = "http://cdnmusic.migu.cn/picture/2019/1227/0914/ALfe993337f19d436b85d6d4dd67266672.jpg"
        let songs = [song,song2,song3]
        
        let songSinger = SongUser()
        songSinger.nickname = "孙燕姿"

        song.singer = songSinger
        song2.singer = songSinger
        song3.singer = songSinger
        
        PlayListManager.shared().setPlayList(songs)
        
        PlayListManager.shared().play(song2)

    }
    
    func setJacksonList(){
        let songUrl = "http://freetyst.nf.migu.cn/public/product5th/product35/2019/09/2616/2018%E5%B9%B409%E6%9C%8807%E6%97%A513%E7%82%B902%E5%88%86%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5SONY900%E9%A6%96/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005970VLPJ.mp3"
        let song = Song()
        song.uri = songUrl
        song.id = "11"
        song.title = "Beat It"
        song.banner = ""
        let songUrl2 = "http://freetyst.nf.migu.cn/public/product8th/product40/2020/05/1416/2018%E5%B9%B409%E6%9C%8807%E6%97%A513%E7%82%B902%E5%88%86%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5SONY900%E9%A6%96/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005970VLPM160811.mp3"
        let song2 = Song()
        song2.uri = songUrl2
        song2.id = "12"
        song2.title = "Man In The Mirror"
        song2.banner = ""
        let songUrl3 = "http://freetyst.nf.migu.cn/public/ringmaker01/n17/2017/06/2015%E5%B9%B409%E6%9C%8828%E6%97%A510%E7%82%B923%E5%88%86%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5SONY577%E9%A6%96/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/Jam%20%28Remastered%20Version%29-Michael%20Jackson.mp3"

          
        let song3 = Song()
        song3.uri = songUrl3
        song3.id = "13"
        song3.title = "Jam"
        song3.banner = ""
        let songs = [song,song2,song3]
        
        let songSinger = SongUser()
        songSinger.nickname = "Jackson"
        
        song.singer = songSinger
        song2.singer = songSinger
        song3.singer = songSinger
        
        PlayListManager.shared().setPlayList(songs)
        PlayListManager.shared().play(song)
    }
    
    func setSingle(){
        let songUrl = "http://freetyst.nf.migu.cn/public/product07/2018/01/25/2017%E5%B9%B409%E6%9C%8811%E6%97%A514%E7%82%B929%E5%88%86%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5%E5%8D%8E%E5%AE%87%E4%B8%96%E5%8D%9A993%E9%A6%96/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/%E7%94%9F%E6%B4%BB%E5%9B%A0%E4%BD%A0%E8%80%8C%E7%81%AB%E7%83%AD-%E6%96%B0%E8%A3%A4%E5%AD%90.mp3"
        let song = Song()
        song.uri = songUrl
        song.id = "21"
        song.title = "生活因你而火热"
        song.lrcUrl = "生活因你而火热"
        song.banner = "http://cdnmusic.migu.cn/picture/2017/1214/0856/AL96cb741205af4cd19cae67755180a1d7.jpg"
        let songSinger = SongUser()
        songSinger.nickname = "新裤子乐队"
        
        song.singer = songSinger
        
        let songs = [song]
        
        PlayListManager.shared().setPlayList(songs)
        PlayListManager.shared().play(song)
    }
}
