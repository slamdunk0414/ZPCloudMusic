//
//  MeTitleModel.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

class MeTitleModel {
    
    var title:String!
    
    var icon :String!
    
    var clickBlock:(()->Void)?
    
    init(title:String,icon:String,block:(()->Void)?) {
        
        self.title = title
        self.icon = icon
        
        if let block = block {
            self.clickBlock = block
        }
    }
}
