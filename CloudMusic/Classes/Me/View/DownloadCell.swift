//
//  DownloadCell.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/7/1.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

import SwiftEventBus

class DownloadCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var indexPath:IndexPath!
    
    /// 下载信息
    var data:DownloadInfo!
    
    func bindData(_ data:DownloadInfo) {
        self.data=data
        
        //根据Id查询业务信息
        let song = ORMUtil.shared().findSongById(data.id)!
        
        titleLabel.text=song.title
        
        setDownloadCallback()
        
        refresh(false)
    }
    
    func setDownloadCallback(){
        weak var weakSelf = self
        
        //设置下载回调
        data.downloadBlock = {
            downloadInfo in
            weakSelf?.refresh(true)
        }
    }
    
    func refresh(_ needNotice:Bool){
        switch data.status {
        case .paused:
            //暂停
            progressView.isHidden=false
            infoLabel.text="已暂停，点击继续下载"
        case .error:
            //下载失败了
            progressView.isHidden=true
            infoLabel.text="下载失败，点击重试"
        case .downloading, .prepareDownload:
            //下载中，准备下载
            progressView.isHidden=false
            
            //计算进度
            if data.size > 0 {
                //计算下载百分比
                //0~1
                progressView.progress=Float(Double(data.progress)/Double(data.size))
                
                //格式化进度
                let start=FileUtil.formatFileSize(data.progress)
                let size=FileUtil.formatFileSize(data.size)
                infoLabel.text="\(start)/\(size)"
            }
        case .completed:
            //下载完成
            
            //该界面不会显示该状态的任务
            //所以要发送通知
            //然界面接收到
            //从而移除这样的任务
            
            publishDownloadStatusChangedEvent(needNotice)
        case .wait:
            //等待中
            progressView.isHidden=true
            infoLabel.text="等待中，点击暂停"
        default:
            //未下载状态
            
            //点击删除任务后
            publishDownloadStatusChangedEvent(needNotice)
        }
    }
        
    /// 发送数据改变了通知
    func publishDownloadStatusChangedEvent(_ isDownloadManagerNotify:Bool) {
            if isDownloadManagerNotify {
                SwiftEventBus.post(ON_DOWNLOAD_STATUS_CHANGED, sender: indexPath)
        }
    }
}
