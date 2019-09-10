//
//  ViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/8/27.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserLoginController: UIViewController {
    
    @IBOutlet weak var userSignUpView: UserSignUpView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUserSignUpView()
        
        // Add for FirebaseAccountManager
        FirebaseAccountManager.shared.belongToVC = self
    }
    
    func setUpUserSignUpView() {
        
        userSignUpView.confirmButton.addTarget(self, action: #selector(onClickRegister), for: .touchUpInside)
    }
    
    // MARK: Firebase 註冊
    @objc func onClickRegister() {
        
        FirebaseAccountManager.shared.onClickRegister(userSignUpView)
    }
    
    // MARK: Firebase 登入
    @objc func onClickLogin() {
        
        FirebaseAccountManager.shared.onClickLogin(userSignUpView)
    }
    
    // MARK: Firebase 登出
    @objc func onClickLogout() {
        
        FirebaseAccountManager.shared.onClickLogout()
    }
    
    // MARK: Firebase 密碼重設
    @objc func onResetPassword() {
        
    }
    
}
