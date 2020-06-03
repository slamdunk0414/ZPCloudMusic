//
//  UIColor+Extention.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

public extension UIColor{

    convenience init(hexColor:Int) {
        let hexRed = CGFloat((hexColor>>16)&0xFF)
        let hexGreen = CGFloat((hexColor>>8)&0xFF)
        let hexBlue = CGFloat(hexColor&0xFF)
        self.init(red: hexRed/CGFloat(255), green: hexGreen/CGFloat(255), blue: hexBlue/CGFloat(255), alpha: 1.0)
    }

}
