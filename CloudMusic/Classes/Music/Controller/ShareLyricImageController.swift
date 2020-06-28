//
//  ShareLyricImageController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ShareLyricImageController: BaseViewController {

    /// 滚动试图容器控件
    @IBOutlet weak var svContaiiner: UIScrollView!
    
    /// 封面图片
    @IBOutlet weak var ivCover: UIImageView!
    
    
    /// 歌词控件
    @IBOutlet weak var blLyric: UILabel!
    
    
    /// 歌曲名称
    @IBOutlet weak var lbSongName: UILabel!
    

    /// 保存歌词图片
    @IBOutlet weak var btSaveLyricImage: UIButton!
    
    /// 音乐
    var song:Song!
    
    /// 歌词
    var lyric:String!
    
    override func initViews() {
        super.initViews()
        
        setTitle("分享歌词图片")
        
        btSaveLyricImage.showColorPrimaryBorder()
    }
    
    override func initDatas() {
        super.initDatas()
        
        //显示封面
        ImageUtil.show(ivCover, song.banner)
        
        //使用富文本
        let attrString = NSMutableAttributedString(string: lyric)
        
        let style = NSMutableParagraphStyle.init()
        
        //设置行高是多少倍
        style.lineHeightMultiple = 1.1
        
        //设置样式到属性文本
        attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: lyric.count))
        
        blLyric.attributedText = attrString
        
        //设置歌曲名称
        lbSongName.text = "——「\(song.title!)」"
    }

    @IBAction func onClickSave(_ sender: Any) {
        let image = ViewUtil.captureScrollView(svContaiiner)
        
        saveImage(image)
    }
    
    /// 保存图片到相册
    ///
    /// - Parameter data: <#data description#>
    func saveImage(_ data:UIImage) {
        UIImageWriteToSavedPhotosAlbum(data, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    /// 保存图片到相册回调
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - error: <#error description#>
    ///   - contextInfo: <#contextInfo description#>
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        var message = ""
        
        if error == nil {
            message="保存成功！"
        } else {
            message="保存失败，请稍后再试！"
        }
        
        ToastUtil.short(message)
    }
    
}

// MARK: - 启动界面
extension ShareLyricImageController {
    
    /// 启动界面
    static func start(_ navigationController:UINavigationController,_ song:Song,_ lyric:String) {
        //创建控制器
        let controller = ShareLyricImageController()
        
        //传递数据
        controller.song = song
        controller.lyric = lyric
        
        navigationController.pushViewController(controller, animated: true)
        
    }
}
