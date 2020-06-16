//
//  BaseViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit
//导入RxSwift框架
import RxSwift


class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDatas()
        
        initViews()
    }
    
    func initViews(){
        
    }
    
    func initDatas(){
        
    }

}
