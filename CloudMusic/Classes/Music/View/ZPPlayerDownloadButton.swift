//
//  ZPPlayerDownloadButton.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPPlayerDownloadButton: UIButton {

    /// 下载器
    var downloader:DownloadManager = DownloadManager.sharedInstance()
    
    /// 数据库工具类
    var orm:ORMUtil = ORMUtil.shared()
    
    /// 下载信息
    var downloadInfo:DownloadInfo?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.addTarget(self, action:#selector(touch), for: .touchUpInside)
        
    }
    
    /// 歌曲改变了 确认自己的状态
    func songChanged(){
        //下载状态
        //根据Id查询当前音乐是否下载
        downloadInfo = downloader.findDownloadInfo(getDownloadInfoId())
        
        if let _ = downloadInfo {
            //有下载任务
            setDownloadCallback()
        }
        
        //不管有没有下载任务
        //都要刷新界面
        refreh()
    }
    
    /// 设置下载回调
    func setDownloadCallback() {
        //使用弱引用
        weak var weakSelf = self
        
        downloadInfo!.downloadBlock = {
            downloadInfo in
            weakSelf?.refreh()
        }
    }
    
    // MARK: -  下载相关
    
    /// 根据下载状态刷新界面
    func refreh() {
        if let downloadInfo = downloadInfo {
            //有下载任务
            
            switch downloadInfo.status {
            case .completed:
                //下载完成
                
                self.setImage(UIImage(named: "DownloadSelected"), for: .normal)
            default:
                //其他状态
                //都显示未下载
                //当然也可以监听下载进度
                normalDownloadStatusUI()
            }
            
            //这里不需要知道更详细的下载状态
            //所以就没有判断
            //会在下载管理里面判断
            //打印下载进度
            let start = downloadInfo.progress
            let size = downloadInfo.size
            print("PlayerController refresh:\(start),\(size)")
        }else {
            //没有下载任务
            normalDownloadStatusUI()
        }
    }
    
    func normalDownloadStatusUI(){
        self.setImage(UIImage(named: "Download"), for: .normal)
    }
    
    /// 获取当前下载任务Id
    func getDownloadInfoId() -> String {
        return "\(PlayListManager.shared().data!.id!))"
    }
    
    ///开始下载
    @objc func touch() {
        //判断是否有下载任务
        if let downloadInfo = downloadInfo {
            //有下载任务
            
            //判断下载状态
            if downloadInfo.status == .completed {
                ToastUtil.short("该歌曲已经下载了！")
            }else {
                //其他状态
                //可能是下载中，等待中
                //下载失败
                ToastUtil.short("已经在下载列表中了！")
            }
        }else {
            //没有下载任务
            createDownload()
        }
    }
    
    /// 创建下载任务
    func createDownload() {
        let song = PlayListManager.shared().data!
        
        guard let urlString = song.uri else {
            return
        }

        //计算保存的路径
        //保存路径在Documents目录下
        //这里要设置相对路径：CocoaDownloader/用户Id/歌曲uri
        //路径中添加用户Id是实现多用户
        //当然这里很明显的问题是
        //如果多用户都下载一首音乐
        //会导致一首音乐会下载多次
        let path = "CocoaDownloader/\(PreferenceUtil.userId()!)/\(song.uri!)"
        
        print("PlayerController createDownload:\(path)")
        
        //创建下载任务
        downloadInfo = DownloadInfo()
        
        //设置保存路径
        downloadInfo!.path=path
        
        //设置下载的网址
        downloadInfo!.uri=urlString
        
        //设置Id
        downloadInfo!.id=getDownloadInfoId()
        
        //获取系统当前时间
        let date = NSDate(timeIntervalSinceNow: 0)
        
        //转为时间戳
        let currentTimeMillis = date.timeIntervalSince1970
        
        //设置创建时间
        //用于显示下载中
        //下载完成列表排序
        //默认按时间
        downloadInfo!.createdAt=currentTimeMillis
        
        //设置下载回调
        setDownloadCallback()
        
        //开始下载了
        downloader.download(downloadInfo!)
        
        //保存业务数据
        orm.saveSong(song)
        
        ToastUtil.short("下载任务添加成功！")
    }

}
