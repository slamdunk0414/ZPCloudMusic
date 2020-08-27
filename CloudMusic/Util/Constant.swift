//
//  Constant.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation


/// 边框宽度
let SIZE_BORDER = 1.0

/// 密码格式不正确
let ERROR_PASSWORD_FORMAT = "密码格式不正确！"

/// 屏幕的宽度
let ZScreenWidth = UIScreen.main.bounds.width
/// 屏幕的高度
let ZScreenHeight = UIScreen.main.bounds.height

/// 单一的导航栏高度
let ZSingleNavigationHeight = CGFloat(44)

/// 单一的tabbar高度
let ZSingleTabbarHeight = CGFloat(39)

/// 获取tabbar的高度
let ZTabBarHeight = SafeFrameUtil.getSafeAreaBottom() + ZSingleTabbarHeight

/// 获取导航栏的高度
let ZNaviationHeight = SafeFrameUtil.getSafeAreaTop() + ZSingleNavigationHeight

/// 开始旋转黑胶唱片事件
let ON_START_RECORD = "ON_START_RECORD"

/// 停止旋转黑胶唱片事件
let ON_STOP_RECORD = "ON_STOP_RECORD"
