//
//  Regex.swift
//  TFT
//
//  Created by wanglei on 18/10/29.
//  Copyright © 2018 wanglei. All rights reserved.
//

import UIKit

public struct RegexHelper {
    
    private let regex: NSRegularExpression
    
    init(_ pattern: Regex) throws {
        try regex = NSRegularExpression(pattern: pattern.rawValue, options: .caseInsensitive)
    }
    
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}

// Swift 中新加操作符的时候需要先对其进行声明，告诉编译器这个符合其实是一个操作符合
// precedencegroup 定义了一个操作符的优先级别
precedencegroup MatchPrecedence {
    // associativity 定义了结合定律，多个同类操作符顺序出现的计算顺序
    associativity: none
    // higherThan 运算的优先级
    higherThan: DefaultPrecedence
}

// 示例: "15600392079" =~ .tel
// infix 表示定位的是一个中位操作符，意思是前后都是输入；
// 其他的修饰子还包括 prefix 和 postfix
infix operator =~: MatchPrecedence

public func =~(object: String, template: Regex) -> Bool {
    do {
        return try RegexHelper(template).match(object)
    } catch _ {
        return false
    }
}



