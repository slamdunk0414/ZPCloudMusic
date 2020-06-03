//
//  ZPRegisterViewController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/5/29.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit
import Moya
import RxSwift

class ZPRegisterViewController: BaseViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var confirmPassWordTextField: UITextField!
    
    
    override func initViews(){
        super.initViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func registerClick(_ sender: Any) {

//        CustomNetworkUtil.shared.sheets().subscribe({ (response) in
//            
//        }) { (error) in
//            print("error")
//            ToastUtil.hideLoading()
//        }
        
        CustomNetworkUtil.shared.sheetDetail(id: "100000").subscribe({ (response) in
            
        }) { (error) in
            
        }
        
//        guard let nickName:String = nickNameTextField?.text?.trim() , nickName =~ .nickname else {
//
////            ToastUtil.short("请输入正确的手机号")
//            ToastUtil.showLoading()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                ToastUtil.hideLoading()
//            }
//
//            return
//        }
//
//        print("registerClick")
    }
    
    @IBAction func xieyiClick(_ sender: Any) {
        print("协议Click")
    }
    
}
