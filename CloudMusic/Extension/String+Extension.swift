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
    
    /// 从指定位置截取文本到末尾
    ///
    /// - Parameter i: 从什么位置开始截取
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    /// 截取到指定位置
    ///
    /// - Parameter toIndex: 要截取到的位置
    /// - Returns: <#return value description#>
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    /// 支持通过数组的方式截取文本
    ///
    /// - Parameter r: <#r description#>
    subscript (r: Range<Int>) -> String {
        //创建一个范围
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)), upper: min(count, max(0, r.upperBound))))
        
        //开始位置
        let start = index(startIndex, offsetBy: range.lowerBound)
        
        //结束位置
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        
        //截取字符串并创建一个字符串返回
        return String(self[start ..< end])
    }
    
    /// 将一行字符串
    /// 拆分为单个字
    ///
    /// - Parameter line: <#line description#>
    /// - Returns: <#return value description#>
    func words() -> [String] {
        var results:[String]=[]
        for char in self {
            //循环每个字
            results.append(String(char))
        }
        
        return results
    }
    
}
