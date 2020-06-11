//
//  Single+Extension.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/11.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response { 
    
    func customResponse() -> Observable<String>{
        return filterSuccessfulStatusCodes().mapString().asObservable()
    }
    
}
