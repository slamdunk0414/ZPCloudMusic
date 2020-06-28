//
//  BaseViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit
//导入RxSwift框架
import RxSwift


class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDatas()
        
        initViews()
        
        initListener()
        
    }
    
    func initViews(){
        //设置导航栏返回按钮颜色为黑色
        setNavigationBarTintColor(UIColor.black)
    }
    
    func initDatas(){
        
    }
    
    func initListener(){
        
    }
    
    /// 设置标题
    ///
    /// - Parameter title: <#title description#>
    func setTitle(_ title:String) {
        navigationItem.title=title
    }
    
    /// 设置导航栏返回按钮颜色
    ///
    /// - Parameter color: <#color description#>
    func setNavigationBarTintColor(_ color:UIColor) {
        navigationController!.navigationBar.tintColor=color
    }
    
    /// 设置导航栏标题文本颜色
    ///
    /// - Parameter color: <#color description#>
    func setTitleTextColor(_ color:UIColor) {
        navigationController?.navigationBar.titleTextAttributes=[.foregroundColor:color]
    }
    
    /// 是否隐藏导航栏
    ///
    /// - Returns: true:隐藏；false:显示（默认）
    func hideNavigationBar() -> Bool {
        return false
    }
    
    /// 视图即将可见
    ///
    /// - Parameter animated: <#animated description#>
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("BaseTitleController viewWillAppear")
        
        if hideNavigationBar() {
            //隐藏导航栏
            navigationController!.setNavigationBarHidden(true, animated: true)
        }else{
            setTitleBarDefault()
        }
    }
    
    /// 视图即将消失
    ///
    /// - Parameter animated: <#animated description#>
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("BaseTitleController viewWillDisappear")
        
        if hideNavigationBar() {
            //显示导航栏
            //因为其他界面可能不需要隐藏
            navigationController!.setNavigationBarHidden(false, animated: true)
        }
    }
    
    /// 设置标题栏（导航栏）为透明
    func setTitleBarTransparet() {
        //设置导航栏透明
        navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        //去除导航栏下面的阴影
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
        /// 设置标题为亮色
        /// 标题栏透明
        /// 文字颜色为白色
        func setTitleBarLight() {
            setTitleBarTransparet()
            
            //设置导航栏样式
            //这里将导航栏的背景设置为黑色
            //这样的话状态栏文字颜色就会自动变为白色
            //如果界面有了导航栏只能通过这种方式修改
            navigationController!.navigationBar.barStyle = .black
            
            //设置返回按钮为白色
            setNavigationBarTintColor(.white)
            
            setTitleTextColor(.white)
        }
        
        /// 设置标题为黑色
        /// 导航栏不透明
        /// 文本颜色是黑色
        func setTitleBarDefault() {
            setTitleBarTransparet()
            
            //还原导航栏样式
            navigationController!.navigationBar.barStyle = .default
            
            //设置返回按钮为黑色
            setNavigationBarTintColor(.black)
            setTitleTextColor(.black)
        }

}
