//
//  UIKit+Extension.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/19.
//  Copyright © 2020 张鹏. All rights reserved.
//

import Foundation

protocol NibLoadable {}

extension NibLoadable {
    static func loadViewFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}
