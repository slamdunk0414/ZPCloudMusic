//
//  ZPSongRecordCell.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/18.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

import SwiftEventBus

class ZPSongRecordCell: UICollectionViewCell {
    /// 黑胶唱片容器
    @IBOutlet weak var content: UIView!

    @IBOutlet weak var banner: UIImageView!

    /// 音乐
    var data:Song!
    
    /// 刷新任务
    var displayLink:CADisplayLink?
    
    override func awakeFromNib() {
        
        initListeners()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        banner.setRaduis(banner.width/2.0)
        
    }
    
    /// 绑定数据
    ///
    /// - Parameter data: <#data description#>
    func bindData(_ data:Song) {
        self.data = data
        
        //显示封面
        ImageUtil.show(banner, data.banner)
    }
    
    func initListeners() {

        //监听启动旋转黑胶唱片事件
        SwiftEventBus.onMainThread(self, name: ON_START_RECORD) { result in
            //获取到事件里面的音乐
            let data = result?.object as! Song
            
            if self.data.id == data.id {
                //是当前Cell的事件
                print("SongRecordCell start:\(data.title)")
                
                self.startCoverRotate()
            }
        }
        
        //监听停止旋转黑胶唱片事件
        SwiftEventBus.onMainThread(self, name: ON_STOP_RECORD) { result in
            //获取到事件里面的音乐
            let data = result?.object as! Song
            
            if self.data.id == data.id {
                //是当前Cell的事件
                print("SongRecordCell stop:\(data.title)")
                
                self.stopCoverRotate()
            }
        }
    }
    
    /// 开始旋转
    func startCoverRotate() {
        if let _ = displayLink {
            //已经启动了
            return
        }
        
        //创建一个定时器任务
        displayLink = CADisplayLink(target: self, selector: #selector(runRotate))
        
        //添加到主循环中
        displayLink!.add(to: RunLoop.main, forMode: .default)
    }
    
    /// 停止旋转
    func stopCoverRotate() {
        if let displayLink = displayLink {
            displayLink.invalidate()
            self.displayLink = nil
        }
    }
    
    /// 旋转
    /// 每帧调用
    @objc func runRotate() {
        //print("SongRecordCell runRotate:\(data.title)")
        //在已有的基础上
        //旋转指定的弧度
        //角度转弧度：度数 * (π / 180）
        //在Android项目中我们测得每16毫秒转0.2304度(用秒表测转一圈的时间)
        //0.2304*(PI/180)=0.004021238596595
        
        //在原来的基础上每16毫秒
        //顺时针选中0.004021238596595弧度
        
        //concatenating：表示在原来的基础上进行变换
        content.transform = CGAffineTransform(rotationAngle: 0.004).concatenating(content.transform)
    }
}
