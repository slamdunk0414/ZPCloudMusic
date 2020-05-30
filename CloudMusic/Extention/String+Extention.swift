//
//  String+Extention.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

extension String {
    
    /// 去除字符串首尾的空格和换行
    ///
    /// - Returns: 返回新的字符串
    mutating func trim() -> String{
        let whitespace=NSCharacterSet.whitespacesAndNewlines
        
//        self = trimmingCharacters(in: whitespace)
        
        return trimmingCharacters(in: whitespace)
        
    }
    
}
