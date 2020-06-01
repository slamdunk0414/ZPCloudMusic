//
//  ZPMusicModel.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/30.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation
import HandyJSON

struct sheet:HandyJSON{
    
    var title:String?
    
}

struct sheetWraper:HandyJSON{
    
    
    var data:sheet!
    
}
