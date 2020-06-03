//
//  BaseResponse.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/3.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

//导入JSON解析框架
import HandyJSON

class BaseResponse: HandyJSON {
    
    /// 状态码
    /// 只有发生了错误才会有
    var status:Int?
    
    /// 错误信息
    /// 发生了错误不一定有
    var message:String?
    
    //JSON解析框架要求有一个init方法
    required init(){}
}

