//
//  MeTableViewCell.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class MeTableViewCell: UITableViewCell {

    var model:MeTitleModel!{
        didSet{
            
            iv?.image = UIImage(named: model.icon)
            
            titleLabel?.text = model.title
            
        }
    }
    
    @IBOutlet weak var iv: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
}
