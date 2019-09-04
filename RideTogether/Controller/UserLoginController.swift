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
    
    @IBOutlet weak var userSignInView: UserSignInView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUserSignInView()
        
        // Add for FirebaseAccountManager
        FirebaseAccountManager.shared.belongToVC = self
        
        // 功能測試
//        FirebaseDataManeger.shared.createGroup("台北")
        
//        FirebaseDataManeger.shared.addMemberInGroup("Ac02rEDtWurlZepI671b", "wind19891001")
        
//        FirebaseDataManeger.shared.modifyGroupName("Ac02rEDtWurlZepI671b", "基隆")
        
//        FirebaseDataManeger.shared.searchUserInfo("userID")

//        FirebaseDataManeger.shared.searchUserGroup("user2ID")

    }
    
    func setUpUserSignInView() {
        
        userSignInView.confirmButton.addTarget(self, action: #selector(onClickLogin), for: .touchUpInside)
                
        userSignInView.logoutButton.addTarget(self, action: #selector(onClickLogout), for: .touchUpInside)
    }
    
    // MARK: Firebase 註冊
    @objc func onClickRegister() {
        
        FirebaseAccountManager.shared.onClickRegister(userSignInView)
    }
    
    // MARK: Firebase 登入
    @objc func onClickLogin() {
        
        FirebaseAccountManager.shared.onClickLogin(userSignInView)
    }
    
    // MARK: Firebase 登出
    @objc func onClickLogout() {
        
        FirebaseAccountManager.shared.onClickLogout()
    }
    
    // MARK: Firebase 密碼重設
    @objc func onResetPassword() {
        
    }
    
}
