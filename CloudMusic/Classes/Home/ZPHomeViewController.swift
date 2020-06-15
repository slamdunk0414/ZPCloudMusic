//
//  ZPHomeViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/4.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPHomeViewController: BaseViewController {

    override func initViews() {
        
        self.view.backgroundColor = .white

    }
    
    //点击了孙燕姿
    @IBAction func clickYanZi(){
        //测试音乐数据
        let songUrl = "http://freetyst.nf.migu.cn/public/product4th/product36/2019/09/0623/2018%E5%B9%B409%E6%9C%8823%E6%97%A513%E7%82%B925%E5%88%86%E6%89%B9%E9%87%8F%E9%A1%B9%E7%9B%AE%E5%8D%8E%E7%BA%B343%E9%A6%96-15/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005751F94D.mp3"
        let song = Song()
        song.uri = songUrl
        song.title = "逆光 -- 孙燕姿"
        let songUrl2 = "http://freetyst.nf.migu.cn/public/product8th/product40/2020/06/0300/2020%E5%B9%B406%E6%9C%8802%E6%97%A519%E7%82%B904%E5%88%86%E7%B4%A7%E6%80%A5%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5%E5%8D%8E%E7%BA%B31%E9%A6%96275504/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005752GQ4A003947.mp3"
        let song2 = Song()
        song2.uri = songUrl2
        song2.title = "开始懂了 -- 孙燕姿"

        let songUrl3 = "http://freetyst.nf.migu.cn/public/product9th/product41/2020/06/1018/2020%E5%B9%B406%E6%9C%8810%E6%97%A507%E7%82%B913%E5%88%86%E7%B4%A7%E6%80%A5%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5%E5%8D%8E%E7%BA%B319%E9%A6%96800531/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005752HBA8180907.mp3"

          
        let song3 = Song()
        song3.uri = songUrl3
        song3.title = "遇见 -- 孙燕姿"
        let songs = [song,song2,song3]
        
        PlayListManager.shared().setPlayList(songs)
        PlayListManager.shared().play(song)
        
        pushToSimpleController()
    }
    
    @IBAction func clickJackson(){
        
        let songUrl = "http://freetyst.nf.migu.cn/public/product5th/product35/2019/09/2616/2018%E5%B9%B409%E6%9C%8807%E6%97%A513%E7%82%B902%E5%88%86%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5SONY900%E9%A6%96/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005970VLPJ.mp3"
        let song = Song()
        song.uri = songUrl
        song.title = "Beat It -- Jackson"
        let songUrl2 = "http://freetyst.nf.migu.cn/public/product8th/product40/2020/05/1416/2018%E5%B9%B409%E6%9C%8807%E6%97%A513%E7%82%B902%E5%88%86%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5SONY900%E9%A6%96/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/6005970VLPM160811.mp3"
        let song2 = Song()
        song2.uri = songUrl2
        song2.title = "Man In The Mirror -- Jackson"

        let songUrl3 = "http://freetyst.nf.migu.cn/public/ringmaker01/n17/2017/06/2015%E5%B9%B409%E6%9C%8828%E6%97%A510%E7%82%B923%E5%88%86%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5SONY577%E9%A6%96/%E5%85%A8%E6%9B%B2%E8%AF%95%E5%90%AC/Mp3_64_22_16/Jam%20%28Remastered%20Version%29-Michael%20Jackson.mp3"

          
        let song3 = Song()
        song3.uri = songUrl3
        song3.title = "Jam -- Jackson"
        let songs = [song,song2,song3]
        
        PlayListManager.shared().setPlayList(songs)
        PlayListManager.shared().play(song)
        
        pushToSimpleController()
        
    }
    
    func pushToSimpleController() {
        ZPSimpleMusicPlayerController.start(self.navigationController!)
    }
    
}
