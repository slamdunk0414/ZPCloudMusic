//
//  ToastUtil.swift
//  提示；加载等待工具类
//
//  Created by smile on 2019/6/7.
//  Copyright © 2019 ixuea. All rights reserved.
//

import UIKit

class ToastUtil {
    private static var hud:MBProgressHUD?
    
    /// 显示一个短时间（1秒钟）的提示
    ///
    /// - Parameter message: <#message description#>
    static func short(_ message:String?) {
        //创建一个MBProgressHUD
        let hud=MBProgressHUD.showAdded(to: AppDelegate.shared.window!.rootViewController!.view, animated: true)
        
        //只显示文字
        hud.mode = .text
        
        //小矩形的背景颜色
        hud.bezelView.color=UIColor.black
        
        //设置细节文本显示的内容
        hud.detailsLabel.text=message ?? ""
        
        //设置细节文本颜色
        hud.detailsLabel.textColor=UIColor.white
        
        //自动隐藏
        hud.hide(animated: true, afterDelay: 1)
    }
    
    /// 显示一个加载对话框
    ///
    /// - Parameter message: <#message description#>
    static func showLoading(_ message:String) {
        if let _ = hud {
            //已经显示了
            
            //就不在显示
            return
        }
        
        //创建一个MBProgressHUD
        hud=MBProgressHUD.showAdded(to: AppDelegate.shared.window!.rootViewController!.view, animated: true)
        
        //设置背景模糊
        hud!.backgroundView.style=MBProgressHUDBackgroundStyle.solidColor
        
        //设置背景为半透明效果
        //UIColor(white: 0.0：表示创建一个黑色
        //0.1:表示黑色有透明效果，0：完全透明；1：完全不透明（黑色）
        hud!.backgroundView.color=UIColor(white: 0.0, alpha: 0.2)
        
        //小矩形的背景颜色
        hud!.bezelView.color = UIColor(white: 0.0, alpha: 0.8)
        
        //细节文本
        hud!.detailsLabel.text=message
        
        //细节文本的颜色
        hud!.detailsLabel.textColor=UIColor.white
        
        //显示
        hud!.show(animated: true)
    }
    
    /// 显示一个加载对话框；使用默认文字
    static func showLoading() {
        showLoading("拼命加载中.")
    }
    
    /// 隐藏加载提示对话框
    static func hideLoading() {
        if let hud = hud {
            hud.hide(animated: true)
            ToastUtil.hud=nil
        }
        
//        if hud != nil {
//            hud!.hide(animated: true)
//        }
    }
}
