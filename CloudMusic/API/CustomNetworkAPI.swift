//
//  CustomNetworkAPI.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import Moya
import RxSwift

let BASE_URL = "http://dev-my-cloud-music-api-rails.ixuea.com"

/// 接口列表
enum CustomNetworkAPI{
    case sheetDetail(id:String) //歌单详情
    case sheets                 //歌单列表
    
    //创建用户
    case createUser(avatar:String?,nickname:String,phone:String,email:String,password:String,qq_id:String?,weibo_id:String?)
    case login(phone:String?,email:String?,password:String?,qq_id:String?,weibo_id:String?)
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
        case .sheets:
            return "/v1/sheets.json"
        case .createUser:
            return "/v1/users"
        case .login:
            return "/v1/sessions"
        }
    }
    
    // MARK: 请求方式
    var method: Moya.Method {
        
        switch self {
        case .createUser, .login:
            return .post
        default:
            return .get
        }
    }
    // MARK: 返回测试相关的数据
    var sampleData: Data {
        return Data()
    }
    
    // MARK: 请求参数
    var task: Task {
        
        switch self {
            
        case .createUser(let avatar, let nickname, let phone, let email, let password, let qq_id, let weibo_id):
        //将参数编码
        return .requestParameters(parameters: ["avatar":avatar,"nickname":nickname,"phone":phone,"email":email,"password":password,"qq_id":qq_id,"weibo_id":weibo_id], encoding: JSONEncoding.default)
            
        case .login(let phone, let email, let password, let qq_id, let weibo_id):
            return .requestParameters(parameters: ["phone":phone,"email":email,"password":password,"qq_id":qq_id,"weibo_id":weibo_id], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
        
    
    // MARK: 请求头
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
