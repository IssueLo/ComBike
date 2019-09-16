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
    
    var toNextVCHandler: ((UIAlertAction) -> Void)!
    
    @IBAction func backToLastVC() {
        
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLogInView.delegate = self
        
        userSignUpView.delegate = self
    }
    
    // MARK: Firebase 密碼重設
    @objc func onResetPassword() {
        
    }
}

extension UserLogInController: UserLogInViewDelegate {
    
    func toSignUpView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.userLogInView.alpha = 0
            
            self.logInLabel.text = "Sign up"
        })
    }
    
    func userLogIn(userEmail: String?, userPassword: String?) {
        
        guard
            let userEmail = userEmail,
            let userPassword = userPassword
            else { return }
        
        if userEmail == "" {
            
            self.showAlert("email 不可為空白喔")
            
        } else if userPassword == "" {
            
            self.showAlert("密碼不可為空白喔")
            
        } else {
            
            FirebaseAccountManager.shared.onClickLogin(userEmail, userPassword) { [weak self] (error) in
                
                if error != nil {
                    
                    self?.showAlert(error!.localizedDescription)
                    
                    return
                }
                
                self?.showAlert("登入成功", self?.toNextVCHandler)
                
                guard let userUID = Auth.auth().currentUser?.uid else { return }
                
                // 登入成功後取得會員暱稱
                FirebaseDataManeger.shared.searchUserInfo(userUID)
                
                FirebaseAccountManager.shared.userEmail = userEmail
            }
        }
    }
}

extension UserLogInController: UserSignUpViewDelegate {
    
    func toLogInView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.userLogInView.alpha = 1
            
            self.logInLabel.text = "Sign in"
        })
    }
    
    func userSignUp(userName: String?, userEmail: String?, userPassword: String?, confirmPassword: String?) {
        
        guard
            let name = userName,
            let email = userEmail,
            let password = userPassword,
            let confirmPassword = confirmPassword
        else { return }
        
        if name == "" {
            
            self.showAlert("暱稱不可為空白喔")
            
        } else if email == "" {
            
            self.showAlert("email 不可為空白喔")
            
        } else if password == "" {
            
            self.showAlert("密碼不可為空白喔")
            
        } else if password != confirmPassword {
            
            self.showAlert("需輸入兩次相同密碼喔")
            
        } else {
            
            FirebaseAccountManager.shared.onClickRegister(userName: name,
                                                          userEmail: email,
                                                          userPassword: password) { [weak self](error) in
                
                if error != nil {
                    
                    self?.showAlert((error?.localizedDescription)!)
                    
                    return
                }
                
                self?.showAlert("註冊成功，已登入", self?.toNextVCHandler)
                                                            
                // 會員資料儲存到 Firebase
                guard
                    let userUID = Auth.auth().currentUser?.uid
                else { return }
                
                FirebaseDataManeger.shared.addUserInfo(userUID, userName!, userEmail!)
                
                FirebaseAccountManager.shared.userName = userName
                                                            
                FirebaseAccountManager.shared.userEmail = userEmail
            }
        }
    }
}
