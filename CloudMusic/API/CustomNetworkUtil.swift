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
    /// 饿汉式单例
    static let shared = CustomNetworkUtil()
    
    public let provider = MoyaProvider<CustomNetworkAPI>()
    
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
}
