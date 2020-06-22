//
//  MusicPlayListView.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/19.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class MusicPlayListView: UIView,NibLoadable{

    /// 播放列表管理器
    var playListManager = PlayListManager.shared()
    
    @IBOutlet weak var tableView: UITableView!
    
    /// 点击音乐回调
    var onSongClick:((_ data:Song) -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        print("代码创建")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
                
        tableView.register(UINib(nibName: SongListCell.NAME, bundle: nil), forCellReuseIdentifier: SongListCell.NAME)

        print("从布局注册")
        
        initDatas()
    }
    
    
    func initDatas() {
        //选中当前播放的音乐
        scrollPosition()
    }
    
    /// 选中当前播放的这首音乐
    func scrollPosition() {
        let dataArray = playListManager.getPlayList()
        
        var index = -1
        
        //获取当前播放的这首音乐
        let data = playListManager.data!
        
        //变量所有音乐
        //找到当前这首音乐
        for e in dataArray.enumerated() {
            if e.element.id == data.id {
                index = e.offset
                break
            }
        }
        //创建一个IndexPath
        let indexPath = IndexPath(item: index, section: 0)
        //选中这一行
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置内容View的尺寸
        tableView.frame = bounds
    }

}

extension MusicPlayListView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playListManager.getPlayList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: SongListCell.NAME) as! SongListCell
        
        //取出当前位置的数据
        let data = playListManager.getPlayList()[indexPath.row]
        
        //设置Tag
        cell.tag = indexPath.row
        
        //绑定数据
        cell.bindData(data)
        
        //返回Cell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //取出当前位置的数据
        let data = playListManager.getPlayList()[indexPath.row]

        onSongClick?(data)
        
        
    }
    
}
