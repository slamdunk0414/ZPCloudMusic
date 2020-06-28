//
//  ImagePreviewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ImagePreviewController: BaseViewController {
    
    @IBOutlet weak var ivBackground: UIImageView!
    
    @IBOutlet weak var ivCover: UIImageView!
    
    @IBOutlet weak var btClose: UIButton!
    
    @IBOutlet weak var btSaveImage: UIButton!
    
    /// 图片地址
    var data:String!
    
        override func initViews() {
        super.initViews()
        
        //按钮边框
        btClose.showColorPrimaryBorder()
        btSaveImage.showColorPrimaryBorder()
    }

    override func initDatas() {
        super.initDatas()
        
        //显示图片
        ImageUtil.show(ivBackground, data)
        ImageUtil.show(ivCover, data)
    }
    
    /// 是否隐藏导航栏
    ///
    /// - Returns: <#return value description#>
    override func hideNavigationBar() -> Bool {
        return true
    }
    
    /// 关闭按钮点击回调方法
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onCloseClick(_ sender: Any) {
        print("ImagePreviewController onCloseClick")
        
        navigationController!.popViewController(animated: false)
    }
    
    /// 保存图片按钮点击回调方法
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onSaveImageClick(_ sender: Any) {
        print("ImagePreviewController onSaveImageClick")
        
        //直接从ImageView中拿到Image
        saveImage(ivCover.image!)
    }
    
    /// 保存图片到相册
    ///
    /// - Parameter data: <#data description#>
    func saveImage(_ data:UIImage) {
        UIImageWriteToSavedPhotosAlbum(data, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// 保存图片到相册回调
    /// 经测试写到工具类中（静态和实例）
    /// 回调找不到方法
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - error: <#error description#>
    ///   - contextInfo: <#contextInfo description#>
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        var message = ""
        
        if error == nil {
            message = "保存成功！"
        } else {
            message = "保存失败，请稍后再试！"
        }
        
        ToastUtil.short(message)
    }
    
    /// 启动界面
    ///
    /// - Parameters:
    ///   - navigationController: <#navigationController description#>
    ///   - data: <#data description#>
    static func start(_ navigationController:UINavigationController,_ data:String){
        //创建控制器
        let controller = ImagePreviewController(nibName: "ImagePreviewController", bundle: nil)
        
        //保存数据
        controller.data = data
        
        //将控制器压入导航控制器
        navigationController.pushViewController(controller, animated: false)
    }
}
