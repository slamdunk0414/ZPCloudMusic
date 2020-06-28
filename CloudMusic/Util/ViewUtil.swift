//
//  ViewUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

class ViewUtil {
       /// 从ScrollView截图
       ///
       /// - Parameter scrollView: <#scrollView description#>
       /// - Returns: <#return value description#>
       static func captureScrollView(_ scrollView:UIScrollView) -> UIImage {
    
           //下面的代码大家不用理解
           //只需要知道这样写就行了
           //因为他是iOS中绘图相关的知识
           
           //获取绘图上下文
           UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, false, 0.0)
           
           //获取ScrollView的偏移
           let savedContentOffset = scrollView.contentOffset
           
           //获取ScrollView的位置
           let savedFrame = scrollView.frame
           
           //重新设置ScrollView的Frame
           scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
           
           //调用渲染方法
           scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
           
           //然后就可以获取图片
           let image = UIGraphicsGetImageFromCurrentImageContext()
           
           //恢复ScrollView的偏移
           scrollView.contentOffset = savedContentOffset
           
           //恢复ScrollView的frame
           scrollView.frame = savedFrame
           
           //标记绘图结束
           UIGraphicsEndImageContext()
           
           //返回Image
           return image!
       }
}
