//
//  CustomNetworkUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import HandyJSON

struct CustomNetworkUtil {
    
    public static let shareProvider = MoyaProvider<CustomNetworkAPI>()
    
}
