//
//  ZPGuideViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPGuideViewController: UIViewController {

    @IBOutlet weak var loginOrRegisterBtn: UIView!
    @IBOutlet weak var goButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }


    override func viewDidLayoutSubviews() {
        
        let buttonWidth:CGFloat = 130.0
        
        loginOrRegisterBtn.x = (view.width - buttonWidth * 2 )/3
        goButton.x = loginOrRegisterBtn.x * 2 + loginOrRegisterBtn.width
        
        loginOrRegisterBtn.layer.cornerRadius = loginOrRegisterBtn.height/2
        goButton.layer.cornerRadius = goButton.height/2
        
        goButton.layer.borderWidth = 1
        goButton.showBorder(UIColor.init(red: 212/155, green: 0, blue: 0, alpha: 1))
        
        loginOrRegisterBtn.layer.masksToBounds = true
        goButton.layer.masksToBounds = true
        
    }

}
