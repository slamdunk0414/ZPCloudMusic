//
//  DownloadController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/7/1.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

import SwiftEventBus

class DownloadController: BaseViewController {

    @IBOutlet weak var btCancelAll: UIButton!
    @IBOutlet weak var btStartAll: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    /// 下载器
    var downloader:DownloadManager!
    
    /// 数据库工具类
    var orm:ORMUtil!
    
    /// 列表数据源
    var dataArray:[DownloadInfo] = []
    
    /// 是否有正在下载的任务
    var hasDownloading = false
    
    override func initViews() {
        super.initViews()
        
        setTitle("下载管理")
        
        tableView.register(UINib(nibName: "DownloadCell", bundle: nil), forCellReuseIdentifier: "DownloadCell")
    }
    
    override func initListener() {
        super.initListener()
        //监听下载改变状态
        //目的是要从当前列表移除
        //因为当前列表中只显示除下载完成的任务
        SwiftEventBus.onMainThread(self, name: ON_DOWNLOAD_STATUS_CHANGED) { (sender) in
            
            let indexPath =  sender?.object as! IndexPath
            
            self.dataArray.remove(at: indexPath.row)
            
            self.tableView.reloadData()
        }
        
    }
    
    override func initDatas() {
        super.initDatas()
        
        //初始化下载器
        downloader = DownloadManager.sharedInstance()
        
        //初始化数据库工具类
        orm=ORMUtil.shared()
        
        fetchData()
    }
    
    /// 获取数据
    func fetchData() {
        let downloadInfos = downloader.findAllDownloading() as? [DownloadInfo]
        
        if downloadInfos != nil && downloadInfos!.count > 0 {
            //判断是否有正在下载的任务
            for downloadInfo in downloadInfos! {
                if downloadInfo.status == .downloading{
                    //如果有一个状态是下载
                    //按钮的状态就是暂停所有
                    hasDownloading=true
                    break
                }
            }
            
            //有下载任务
            dataArray=dataArray+downloadInfos!
        } else {
            //没有下载任务
        }
        
        tableView.reloadData()
        
        //设置按钮的状态
        setPauseOrResumeButtonStatus()
    }
    
    /// 设置下载/暂停所有任务按钮状态
    func setPauseOrResumeButtonStatus() {
        if hasDownloading {
            btStartAll.setTitle("全部暂停", for: .normal)
        } else {
            btStartAll.setTitle("全部开始", for: .normal)
        }
    }

    /// 暂停/继续所有任务
    func pauseOrResumeAll() {
        if hasDownloading {
            pauseAll()
            hasDownloading=false
        } else {
            resumeAll()
            hasDownloading=true
        }
        
        setPauseOrResumeButtonStatus()
    }
    
    /// 暂停所有
    func pauseAll() {
        downloader.pauseAll()
        tableView.reloadData()
    }
    
    /// 继续所有
    func resumeAll() {
        downloader.resumeAll()
        tableView.reloadData()
    }
    
    @IBAction func onClickStartAll(_ sender: UIButton) {
        
        //无数据
        //可以按照需求来处理
        //原版是没有下载任务不能进入到该界面
        //我们这里就显示一个提示就行了
        
        if dataArray.count == 0 {
            ToastUtil.short("没有下载任务！")
            return
        }
        
        pauseOrResumeAll()
    }
    @IBAction func onClickClearAll(_ sender: UIButton) {
        
        if dataArray.count == 0 {
            ToastUtil.short("没有下载任务！")
            return
        }
        
        for data in dataArray {
            //删除所有下载任务
            downloader.remove(data)
        }
        
        //删除数据源
        dataArray.removeAll()
        
        //列表控件重新加载数据
        tableView.reloadData()
    }
    
}

extension DownloadController: UITableViewDataSource,UITableViewDelegate{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell") as! DownloadCell
        cell.indexPath = indexPath
        cell.bindData(dataArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //获取数据
        let data = dataArray[indexPath.row]
        
        if data.status == .paused || data.status == .error {
            //暂停中
            //错误
            
            //继续下载
            downloader.resume(data)
        } else {
            //暂停
            downloader.pause(data)
        }
        
    }
    
    
}
