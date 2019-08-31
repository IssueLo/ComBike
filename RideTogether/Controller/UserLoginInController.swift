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

class UserLoginInController: UIViewController {
    
    @IBOutlet weak var userSignInView: UserSignInView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUserSignInView()
        
        FirebaseController().searchUserGroup("Luke")
    }
    
    func setUpUserSignInView() {
        
        userSignInView.confirmButton.addTarget(self, action: #selector(onClickLogin), for: .touchUpInside)
        
        userSignInView.logoutButton.addTarget(self, action: #selector(onClickLogout), for: .touchUpInside)
    }
    
    // MARK: Firebase 註冊
    @objc func onClickRegister() {
        
        if userSignInView.userEmailTxtFld.text == "" || userSignInView.userPasswordTxtFld.text == "" {

            showAlert("請輸入信箱跟密碼")
        }
        
        Auth.auth().createUser(withEmail: userSignInView.userEmailTxtFld.text ?? "",
                               password: userSignInView.userPasswordTxtFld.text ?? "") { (_, error) in
                                
                                if error != nil {
                                    
                                    self.showAlert((error?.localizedDescription)!)
                                    
                                    return
                                }
                                
                                self.showAlert("註冊成功，已登入")
                                
        }
    }
    
    // MARK: Firebase 登入
    @objc func onClickLogin() {
        
        if userSignInView.userEmailTxtFld.text == "" || userSignInView.userPasswordTxtFld.text == "" {
            
            showAlert("請輸入信箱跟密碼")
        }
        
        Auth.auth().signIn(withEmail: userSignInView.userEmailTxtFld.text ?? "",
                           password: userSignInView.userPasswordTxtFld.text ?? "") { (_, error) in
                            
                            if error != nil {
                                
                                self.showAlert(error!.localizedDescription)
                                
                                return
                            }
                            
                            self.showAlert("登入成功")
                            
                            print(Auth.auth().currentUser?.uid as Any)
        }
    }
    
    // MARK: Firebase 登出
    @objc func onClickLogout() {
        
        if Auth.auth().currentUser == nil {
            
            showAlert("未登入")
        }
        
        do {
            
            try Auth.auth().signOut()
            
            showAlert("登出成功")
            
        } catch let error as NSError {
            
            showAlert(error.localizedDescription)
        }
    }
    
    // MARK: Firebase 密碼重設
    @objc func onResetPassword() {
        
        if userSignInView.userEmailTxtFld.text == "" {
            
            showAlert("請輸入信箱")
        }
        
        Auth.auth().sendPasswordReset(withEmail: userSignInView.userEmailTxtFld.text ?? "") { (error) in
            
            if error != nil {
                
                self.showAlert(error!.localizedDescription)
                
                return
            }
            
            self.showAlert("重設成功，請檢查信箱信件")
        }
    }
    
    func showAlert(_ message: String) {
        
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
