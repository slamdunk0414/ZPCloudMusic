//
//  RegexEnum.swift
//  TFT
//
//  Created by wanglei on 2018/10/29.
//  Copyright © 2018 宋澎. All rights reserved.
//

import Foundation

public enum Regex: String {
    /// 手机号
    case tel = "^1{1}[3456789]{1}\\d{9}$"
    /// 验证码
    case smsCode = "\\d{6}"
    /// 邮箱
    case email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
    /// 汉字
    case chinese = "[\\u4e00-\\u9fa5]"
    /// 中国大陆身份证号(15位或18位)
    case idNum = "\\d{15}(\\d\\d[0-9xX])?"
    /// 银行卡号的正则
    case bankCard = "^[1-9]\\d{12,18}$"
    /// 匹配密码 字面加下划线，6到18位
    //case password = "^[a-z0-9_-]{6,18}$"
    /// 邮编
    case zipCode = "[1-9]\\d{5}"
    /// 匹配URL
    case url = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
    /// 是HTML<center>内容<\center>符合
    case htmlTag = "^<([a-z]+)([^<]+)*(?:>(.*)<\\/\\1>|\\s+\\/>)$"
    /// 中国大陆固定电话号码
    case fixedLineTel = "(\\d{4}-|\\d{3}-)?(\\d{8}|\\d{7})"
    /// 字母
    case letter = "^[A-Z]+$"
    /// 大于0的整数
    case integer = "[1-9]\\d"
    /// 匹配16进制
    case hexValue = "^#?([a-f0-9]{6}|[a-f0-9]{3})$"
    /// 匹配昵称 2-20个字符可由中英文、数字、“_”、“-”组成
    case nickname = "^[-_0-9a-zA-Z\\u4e00-\\u9fa5\\s*]{2,20}$"
    /// 匹配密码 由数字和字母组成，并且要同时含有数字和字母，且长度要在8-25位之间。
    case password = "^(?![0-9]+$)(?![a-zA-Z]+$)(?![\\W]+$)(?![0-9\\W]+$)(?![a-zA-Z\\W]+$)[0-9A-Za-z\\W]{8,25}$"
    /// 若干个空格（可以是0个）
    case space = "^[\\s*]+$"
}
