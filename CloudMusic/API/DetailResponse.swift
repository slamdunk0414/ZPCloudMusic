//
//  DetailResponse.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/3.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

//导入JSON解析框架
import HandyJSON

class DetailResponse<T: HandyJSON>: BaseResponse {
    
    /// 真实数据
    var data:T?
}
