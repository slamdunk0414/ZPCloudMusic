//
//  UIView+Extention.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
        
    // 扩展 x 的 set get 方法
    var x: CGFloat{
        get{
            return frame.origin.x
        }
        set(newX){
            var tmpFrame: CGRect = frame
            tmpFrame.origin.x = newX
            frame = tmpFrame
        }
    }

    // 扩展 y 的 set get 方法
    var y: CGFloat{
        get{
            return frame.origin.y
        }
        set(newY){
            var tmpFrame: CGRect = frame
            tmpFrame.origin.y = newY
            frame = tmpFrame
        }
    }

    // 扩展 width 的 set get 方法
    var width: CGFloat{
        get{
            return frame.size.width
        }
        set(newWidth){
            var tmpFrameWidth: CGRect = frame
            tmpFrameWidth.size.width = newWidth
            frame = tmpFrameWidth
        }
    }

    // 扩展 height 的 set get 方法
    var height: CGFloat{
        get{
            return frame.size.height
        }
        set(newHeight){
            var tmpFrameHeight: CGRect = frame
            tmpFrameHeight.size.height = newHeight
            frame = tmpFrameHeight
        }
    }

    // 扩展 centerX 的 set get 方法
    var centerX: CGFloat{
        get{
            return center.x
        }
        set(newCenterX){
            center = CGPoint(x: newCenterX, y: center.y)
        }
    }

    // 扩展 centerY 的 set get 方法
    var centerY: CGFloat{
        get{
            return center.y
        }
        set(newCenterY){
            center = CGPoint(x: center.x, y: newCenterY)
        }
    }
    
    // 扩展 origin 的 set get 方法
    var origin: CGPoint{
        get{
            return CGPoint(x: x, y: y)
        }
        set(newOrigin){
            x = newOrigin.x
            y = newOrigin.y
        }
    }

    // 扩展 size 的 set get 方法
    var size: CGSize{
        get{
            return CGSize(width: width, height: height)
        }
        set(newSize){
            width = newSize.width
            height = newSize.height
        }
    }

    // 扩展 left 的 set get 方法
    var left: CGFloat{
        get{
            return x
        }
        set(newLeft){
            x = newLeft
        }
    }

    // 扩展 right 的 set get 方法
    var right: CGFloat{
        get{
            return x + width
        }
        set(newNight){
            x = newNight - width
        }
    }

    // 扩展 top 的 set get 方法
    var top: CGFloat{
        get{
            return y
        }
        set(newTop){
            y = newTop
        }
    }

    // 扩展 bottom 的 set get 方法
    var bottom: CGFloat{
        get{
            return  y + height
        }
        set(newBottom){
            y = newBottom - height
        }
    }
    
    /// 显示边框
    ///
    /// - Parameter color: <#color description#>
    func showBorder(_ color:UIColor) {
        //边框为1
        self.layer.borderWidth=CGFloat(SIZE_BORDER)
        
        self.layer.borderColor=color.cgColor
    }
    
    func setRaduis(_ raduis:CGFloat){
        
        self.layer.cornerRadius = raduis
        self.layer.masksToBounds = true
        
    }
    
    /// 更改View锚点
    /// 会自动修正位置的偏移
    ///
    /// - Parameter anchorPoint:
    func setViewAnchorPoint(_ anchorPoint:CGPoint) {
        //原来的锚点
        let originAnchorPoint = layer.anchorPoint
        
        //要偏移的锚点
        let offetPoint = CGPoint(x: anchorPoint.x - originAnchorPoint.x, y: anchorPoint.y - originAnchorPoint.y)
        
        //要偏移的距离
        let offetX=(offetPoint.x) * frame.size.width
        let offetY=(offetPoint.y) * frame.size.height
        
        //设置这个值 说明已经改变了偏移量
        layer.anchorPoint = anchorPoint
        
//        //将指定的偏宜量更改回来
        layer.position = CGPoint(x: layer.position.x + offetX, y: layer.position.y + offetY)
        
//        var bounds = self.frame
//        
//        let toBounds = CGRect(x: x + offetX , y: y + offetY , width: width, height: height)
//        
//        self.frame = toBounds
        
//        x =  -offetX
//        y =  -offetY
    }
}
