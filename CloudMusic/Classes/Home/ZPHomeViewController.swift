//
//  ZPHomeViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/4.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPHomeViewController: BaseViewController {

    override func initViews() {
        
        self.view.backgroundColor = .white
        
        let view = UIView(frame: CGRect(x: 0, y: ZNaviationHeight, width: 100, height: 100))
        view.backgroundColor = .red
        
        self.view.addSubview(view)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let controller = ZPSimpleMusicPlayerController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
