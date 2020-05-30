//
//  CustomNetworkAPI.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import Moya

let BASE_URL = "http://dev-my-cloud-music-api-rails.ixuea.com"

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
        switch self {
        case .sheetDetail(let id):
            return "/v1/sheets/\(id).json"
        default:
            return ""
        }
    }
    
    // MARK: 请求方式
    var method: Moya.Method {
        .get
    }
    // MARK: 返回测试相关的数据
    var sampleData: Data {
        return Data()
    }
    
    // MARK: 请求参数
    var task: Task {
        return .requestPlain
    }
    
    // MARK: 请求头
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
