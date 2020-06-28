//
//  SelectLyricCell.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class SelectLyricCell: UITableViewCell,NibLoadable{
    
    static let NAME = "SelectLyricCell"
    
    /// 选中标识
    @IBOutlet weak var ivSelected: UIImageView!
    
    /// 歌词标题
    @IBOutlet weak var lbTitle: UILabel!

    func bindData(_ data:LyricLine) {
        lbTitle.text = data.data
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            ivSelected.isHidden=false
        } else {
            ivSelected.isHidden=true
        }
    }

}
