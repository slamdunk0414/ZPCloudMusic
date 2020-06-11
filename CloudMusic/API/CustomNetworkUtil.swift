//
//  CustomNetworkUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/3.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import HandyJSON

struct CustomNetworkUtil {
    
    /// 单例设计模式
    /// 单例
    static let shared = CustomNetworkUtil()
    
    private let provider = MoyaProvider<CustomNetworkAPI>()
    
    private init(){
        
    }
    
    /// 歌单列表
    ///
    /// - Returns: 返回歌单列表
    func sheets() -> Observable<ListResponse<Sheet>?> {
        return provider
            .rx
            .request(.sheets)
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapString()
            .mapObject(ListResponse<Sheet>.self)
    }
    
    func sheetDetail(id:String) -> Observable<DetailResponse<Sheet>?> {
        return provider
            .rx
            .request(.sheetDetail(id: id))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapString()
            .mapObject(DetailResponse<Sheet>.self)
    }
    
    func createUser(avatar:String?=nil,nickname:String,phone:String,email:String,password:String,qq_id:String?=nil,weibo_id:String?=nil) -> Observable<DetailResponse<BaseModel>?> {
        return provider
            .rx
            .request(.createUser(avatar: avatar, nickname: nickname, phone: phone, email: email, password: password, qq_id: qq_id, weibo_id: weibo_id))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapString()
            .mapObject(DetailResponse<BaseModel>.self)
    }
    
    func login(phone:String?=nil,email:String?=nil,password:String?=nil,qq_id:String?=nil,weibo_id:String?=nil) -> Observable<DetailResponse<Session>?> {
        return provider
            .rx
            .request(.login(phone: phone, email: email, password: password, qq_id: qq_id, weibo_id: weibo_id))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
            .mapObject(DetailResponse<Session>.self)
        
        
        provider.rx.request(.sheets)
            .customResponse().mapObject(DetailResponse<Session>.self)
    }
}
