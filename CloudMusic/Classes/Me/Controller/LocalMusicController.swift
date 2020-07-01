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
    
    /// 编辑按钮
    var editBarItem:UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buttonContainer: UIStackView!
    
    @IBOutlet weak var btnSelectAll: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    override func initViews() {
        setTitle("本地音乐")
        
        //右上角添加编辑按钮
        editBarItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(onEditClick(sender:)))
        
        //将按钮添加到导航栏右侧
        navigationItem.rightBarButtonItem=editBarItem
    }
    
    /// 选择所有按钮点击事件
    @IBAction func onSelectAllClick(_ sender: Any) {
        print("LocalMusicController onSelectAllClick")
        
        let selected = isSelected()
        
        for i in 0..<dataArray.count {
            let indexPath = IndexPath(item: i, section: 0)
            
            if selected {
                //有选中
                
                //取消选择
                tableView.deselectRow(at: indexPath, animated: true)
            }else {
                //没有选中
                
                //选择所有
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            }
        }
        
        //刷新按钮状态
        showButtonStatus()
    }
    

    /// 删除点击事件
    @IBAction func onDeleteClick(_ sender: Any) {
        print("LocalMusicController onDeleteClick")
        
        //获取到选中的IndexPath
        let indexPaths = tableView.indexPathsForSelectedRows!
        
        /// 保存要删除的对象id
        var deleteIndex:[String] = []
        
        for indexPath in indexPaths {
            let data = dataArray[indexPath.row]
            
            //从下载框架中删除
            let downloadInfo = downloader.findDownloadInfo(data.id!)
            downloader.remove(downloadInfo)
            
            //从数据源中删除
            //dataArray.remove(at: indexPath.row)
            
            //将要删除对象的Id保存到列表中
            deleteIndex.append(data.id)
        }
        
        playListManager.datum.removeAll { (data) -> Bool in
            
            if data.id == playListManager.data?.id{
                playListManager.pause()
            }
            
            return deleteIndex.contains(data.id)
        }
        
        //删除数据源数据
        dataArray.removeAll { (data) -> Bool in
            return deleteIndex.contains(data.id)
        }
        //删除cell
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        //退出编辑模式
        exitEditMode()
    }
    
    /// 编辑按钮点击
    ///
    /// - Parameter sender: <#sender description#>
    @objc func onEditClick(sender:UIButton) {
        print("LocalMusicController onEditClick")
        
        //判断是否有数据
        if dataArray.count == 0{
            ToastUtil.short("没有本地音乐！")
            return
        }
        
        if tableView.isEditing {
            //在编辑模式下
            
            //退出编辑模式
            exitEditMode()
        } else {
            //没有进入编辑模式
            
            //进入编辑模式
            editBarItem.title="取消编辑"
            
            tableView.setEditing(true, animated: true)
            buttonContainer.isHidden=false
        }
        
    
    }
    
    /// 退出编辑模式
    func exitEditMode() {
        editBarItem.title="编辑"
        
        //退出编辑模式
        tableView.setEditing(false, animated: true)
        buttonContainer.isHidden=true
        
        //按钮重置为默认状态
        defaultButtonStatus()
        
    }
    
    /// 按钮重置为默认状态
    func defaultButtonStatus() {
        btnSelectAll.setTitle("全选", for: .normal)
        
        btnDelete.isEnabled=false
    }
    
    func showButtonStatus(){
        if isSelected() {
            //有选中的条目
            
            btnSelectAll.setTitle("取消全选", for: .normal)
            btnDelete.isEnabled=true
        } else {
            //没有选中的条目
            
            defaultButtonStatus()
        }
    }
    
    /// 是否有选中
    ///
    /// - Returns: <#return value description#>
    func isSelected() -> Bool {
        return tableView.indexPathsForSelectedRows != nil
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            //如果是编辑状态
            //就不进入播放页面
            showButtonStatus()
            return
        }
        
        let song = dataArray[indexPath.row]
        
        playListManager.setPlayList(dataArray)
        
        playListManager.play(song)
        
        let controller = ZPPlayerController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            //如果在编辑模式下
            
            //要想左侧显示的是多选按钮
            //这里需要返回delete和insert
            //如果只返回delete
            //那么左侧显示的是一个减号
            return UITableViewCell.EditingStyle(rawValue: UITableViewCell.EditingStyle.delete.rawValue | UITableViewCell.EditingStyle.insert.rawValue)!
        } else {
            //单选编辑模式
            return .delete
        }
       
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //删除按钮点击回调
            
            //取出当前位置数据
            let data = dataArray[indexPath.row]
            
            if data.id == playListManager.data?.id{
                playListManager.pause()
            }
            
            //从下载框架中删除
            let downloadInfo = downloader.findDownloadInfo(data.id!)
            downloader.remove(downloadInfo)
            
            //从当前列表数据源中删除
            dataArray.remove(at: indexPath.row)
            
            //从tableView中删除cell
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            print("LocalMusicController commit edit delete:\(data.title)")
        }
    }
}
