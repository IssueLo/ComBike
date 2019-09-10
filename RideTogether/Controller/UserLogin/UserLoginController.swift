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

class UserLogInController: UIViewController {
    
    @IBOutlet weak var logInLabel: UILabel!
    
    @IBOutlet weak var userSignUpView: UserSignUpView!
    
    @IBOutlet weak var userLogInView: UserLogInView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add for FirebaseAccountManager
        FirebaseAccountManager.shared.belongToVC = self
        
        setUpUserLogInView()
        
        setUpUserSignUpView()
    }
    
    func setUpUserLogInView() {
        
        userLogInView.delegate = self
        
        userLogInView.toSignUpViewHandler = {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.userLogInView.alpha = 0
                
                self.logInLabel.text = "Sign up"
            })
        }
    }
    
    func setUpUserSignUpView() {
        
        userSignUpView.toLogInViewHandler = {
            
            UIView.animate(withDuration: 0.3, animations: {
            
                self.userLogInView.alpha = 1
                
                self.logInLabel.text = "Sign in"
            })
        }
    }
    
    // MARK: Firebase 註冊
    @objc func onClickRegister() {
        
        FirebaseAccountManager.shared.onClickRegister(userSignUpView)
    }
    
    // MARK: Firebase 登出
    @objc func onClickLogout() {
        
        FirebaseAccountManager.shared.onClickLogout()
    }
    
    // MARK: Firebase 密碼重設
    @objc func onResetPassword() {
        
    }
}

extension UserLogInController: UserLogInViewDelegate {
    
    func userLogIn(userEmail: String?, userPassword: String?) {
        
        guard
            let userEmail = userEmail,
            let userPassword = userPassword
        else { return }
        
        if userEmail == "" {
            
            self.showAlert("email 不可為空白")
            
        } else if userPassword == "" {
            
            self.showAlert("密碼不可為空白")
            
        } else {
            
            FirebaseAccountManager.shared.onClickLogin(userEmail, userPassword)
        }
    }
}
