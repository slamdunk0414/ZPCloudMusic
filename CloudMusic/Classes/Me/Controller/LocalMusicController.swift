//
//  LocalMusicController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class LocalMusicController: BaseViewController {

    /// 列表数据
    var dataArray:[Song] = []
    
    /// 下载管理器
    var downloader:DownloadManager!
    
    /// 播放列表管理器
    var playListManager:PlayListManager!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func initViews() {
        setTitle("本地音乐")
        
    }
    
    override func initDatas() {
        super.initDatas()
        
        //初始化下载管理器
        downloader = DownloadManager.sharedInstance()
        
        //初始化播放列表管理器
        playListManager = PlayListManager.shared()
        
        //查询所有已经下载完成的音乐
        let datas = downloader.findAllDownloaded() as? [DownloadInfo]
        
        if datas != nil && datas!.count > 0 {
            //有下载完成的音乐
            dataArray=dataArray+processSong(datas!)
            
            tableView.reloadData()
        } else {
            //没有下载完成的音乐
            
        }
    }
    
    func processSong(_ datas:[DownloadInfo]) -> [Song] {
        var results:[Song] = []
        
        for data in datas {
            let song = ORMUtil.shared().findSongById(data.id)!
            results.append(song)
        }
        
        return results
    }

}

extension LocalMusicController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let song = dataArray[indexPath.row]
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = song.title
        cell?.detailTextLabel?.text = song.singer.nickname
        
        return cell!
    }
    
    
    
    
}
