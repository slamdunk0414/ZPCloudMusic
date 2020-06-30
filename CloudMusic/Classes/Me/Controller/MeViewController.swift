//
//  MeViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class MeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray:[MeTitleModel] = []
    
    override func initViews() {
        setTitle("我的音乐")
        
        tableView.register((UINib(nibName: "MeTableViewCell", bundle: nil)), forCellReuseIdentifier: "MeTableViewCell")
        
        dataArray.append(MeTitleModel(title: "本地音乐", icon: "LocalMusic", block: { [weak self] in
            self?.pushToLocalMusic()
        }))
        
        dataArray.append(MeTitleModel(title: "下载管理", icon: "musicDownload", block: { [weak self] in
            self?.pushToDownload()
        }))
        
        tableView.reloadData()
    }

    
    func pushToLocalMusic(){
        let controller = LocalMusicController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushToDownload(){
        print("跳转下载管理")
    }
}

extension MeViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeTableViewCell") as! MeTableViewCell
        
        cell.model = dataArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let model = dataArray[indexPath.row]
        
        if model.clickBlock != nil {
            model.clickBlock!()
        }
    }
    
    
}
