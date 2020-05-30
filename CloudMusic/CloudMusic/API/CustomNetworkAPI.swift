//
//  CustomNetworkAPI.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import Moya

let BASE_URL = "www.baidu.com"

/// 接口列表
enum CustomNetworkAPI{
    case sheetDetail(id:String) //歌单详情
    case sheets                 //歌单列表
}

extension CustomNetworkAPI:TargetType{
    
    // MARK: 返回baseURL
    public var baseURL: URL {
        if let url = URL(string: BASE_URL) {
            return url
        }
        return URL(string: "www.baidu.com")!
    }
    
    // MARK: 返回每个请求的路径
    var path: String {
        return "123/123"
    }
    
    // MARK: 请求方式
    var method: Moya.Method {
        .post
    }
    // MARK: 返回测试相关的数据
    var sampleData: Data {
        return Data()
    }
    
    // MARK: 请求参数
    var task: Task {
        return nil
    }
    
    // MARK: 请求头
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
