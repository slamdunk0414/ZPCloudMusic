//
//  VideoList.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/7/2.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class VideoModel{
    ///标题
    var title:String!
    ///背景
    var cover:String!
}

class VideoDetailModel{
    /// 标题
    var title:String!
    
    /// 视频地址
    var uri:String!
    
    /// 封面
    var cover:String!
    
    /// 视频时长
    /// 单位：秒
    var duration = 0
    
    // MARK: - 播放后才有值
    /// 播放进度
    var progress:Float = 0
}
