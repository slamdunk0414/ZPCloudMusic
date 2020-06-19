//
//  ImageUtil.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/18.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

class ImageUtil {
    /// 显示网络图片（相对地址）
    ///
    /// - Returns: <#return value description#>
    static func show(_ imageView:UIImageView,_ uri:String?,_ placeHolder:UIImage? = nil) {
        if let uri = uri {
            //有图片路径

            //创建URL
            let url = URL(string: uri)
            
            //显示图片
            imageView.sd_setImage(with: url, placeholderImage: placeHolder, options: [], completed: nil)
        }else{
            //没有图片路径
            
            showDefaultImage(imageView)
        }
    }
    
    /// 显示默认图片
    ///
    /// - Parameter imageView: imageView description
    static func showDefaultImage(_ imageView:UIImageView) {
        imageView.image = UIImage(named: "PlaceHolder")
    }
}
