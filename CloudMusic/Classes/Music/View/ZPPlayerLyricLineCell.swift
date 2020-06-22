//
//  ZPPlayerLyricLineCell.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/22.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPPlayerLyricLineCell: UITableViewCell {

    var line:LyricLine!
    
    @IBOutlet weak var lbText: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.selectionStyle = .none
    }
    
    
    func bindData(_ line:LyricLine){
        
        self.line = line
        
        lbText.text = line.data
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        if selected {
            
            UIView.animate(withDuration: 0.3) {
                self.lbText.textColor = UIColor(hexColor: COLOR_PRIMARY)
                
                self.lbText.font = UIFont.systemFont(ofSize: 25)
            }
            
            
            
        }else{UIView.animate(withDuration: 0.3) {
                self.lbText.textColor = .lightGray
                self.lbText.font = UIFont.systemFont(ofSize: 17)
            }
        }
        
        
        
    }

}
