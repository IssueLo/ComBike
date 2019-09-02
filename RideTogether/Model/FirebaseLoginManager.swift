//
//  FirebaseLoginManager.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/2.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Firebase
import FirebaseAuth

class FirebaseAccountManager {
    
    static let shared = FirebaseAccountManager()
    
    private init() {}
    
    var belongToVC: UIViewController!
    
    // MARK: Firebase 註冊
    func onClickRegister(_ userSignInView: UserSignInView) {
        
        if userSignInView.userEmailTxtFld.text == "" || userSignInView.userPasswordTxtFld.text == "" {
            
            showAlert(belongToVC, "請輸入信箱跟密碼")
        }
        
        Auth.auth().createUser(withEmail: userSignInView.userEmailTxtFld.text ?? "",
                               password: userSignInView.userPasswordTxtFld.text ?? "") { (_, error) in
                                
                                if error != nil {
                                    
                                    self.showAlert(self.belongToVC, (error?.localizedDescription)!)
                                    
                                    return
                                }
                                
                                self.showAlert(self.belongToVC, "註冊成功，已登入")
        }
    }
    
    // MARK: Firebase 登入
    func onClickLogin(_ userSignInView: UserSignInView) {
        
        if userSignInView.userEmailTxtFld.text == "" || userSignInView.userPasswordTxtFld.text == "" {
            
            showAlert(belongToVC, "請輸入信箱跟密碼")
        }
        
        Auth.auth().signIn(withEmail: userSignInView.userEmailTxtFld.text ?? "",
                           password: userSignInView.userPasswordTxtFld.text ?? "") { (_, error) in
                            
                            if error != nil {
                                
                                self.showAlert(self.belongToVC, error!.localizedDescription)
                                
                                return
                            }
                            
                            self.showAlert(self.belongToVC, "登入成功")
                            
                            print(Auth.auth().currentUser?.uid as Any)
        }
    }
    
    // MARK: Firebase 登出
    func onClickLogout() {
        
        if Auth.auth().currentUser == nil {
            
            showAlert(self.belongToVC, "未登入")
        }
        
        do {
            
            try Auth.auth().signOut()
            
            showAlert(belongToVC, "登出成功")
            
        } catch let error as NSError {
            
            showAlert(belongToVC, error.localizedDescription)
        }
    }
    
    // MARK: Firebase 密碼重設
    func onResetPasswor(_ userSignInView: UserSignInView) {
        
        if userSignInView.userEmailTxtFld.text == "" {
            
            showAlert(belongToVC, "請輸入信箱")
        }
        
        Auth.auth().sendPasswordReset(withEmail: userSignInView.userEmailTxtFld.text ?? "") { (error) in
            
            if error != nil {
                
                self.showAlert(self.belongToVC, error!.localizedDescription)
                
                return
            }
            
            self.showAlert(self.belongToVC, "重設成功，請檢查信箱信件")
        }
    }
    
    private func showAlert(_ belongToVC: UIViewController,
                           _ message: String) {
        
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        belongToVC.present(alertController, animated: true, completion: nil)
    }
    
}
