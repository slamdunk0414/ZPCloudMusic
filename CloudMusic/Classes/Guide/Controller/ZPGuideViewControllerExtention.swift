//
//  ZPGuideViewControllerExtention.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

extension ZPGuideViewController{
    func initBannerView(){
        
        bannerView.delegate = self
        bannerView.dataSource = self
        
        //指示器默认颜色
        bannerView.pageControlNormalColor=UIColor(hexColor: COLOR_LIGHT_GREY)
        
        //高亮颜色
        bannerView.pageControlHighlightColor=UIColor(hexColor: COLOR_PRIMARY)
        
        //禁用自动滚动
        bannerView.autoScroll=false
        
        //重新加载数据
        bannerView.reloadData()
    }
}

extension ZPGuideViewController: YJBannerViewDelegate,YJBannerViewDataSource{
        func bannerViewImages(_ bannerView: YJBannerView!) -> [Any]! {
            return ["1","2","3"]
        }
        
        func bannerViewTitles(_ bannerView: YJBannerView!) -> [Any]! {
            return ["1","2","3"]
        }

        func bannerView(_ bannerView: YJBannerView!, customCell: UICollectionViewCell!, index: Int) -> UICollectionViewCell! {

            let cell  = customCell as! YJBannerViewCell
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            label.text = "112233"
            label.textColor = .blue
    //        cell.addSubview(label)
            
            cell.contentView.addSubview(label)

            return cell
        }
}
