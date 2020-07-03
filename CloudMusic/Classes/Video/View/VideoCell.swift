//
//  VideoCell.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/7/2.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var model:VideoDetailModel!{
        didSet{
            
            coverImageView.sd_setImage(with: URL(string: model.cover), completed: nil)
            
            titleLabel.text = model.title
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
