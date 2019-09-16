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
    
    var userUID: String? {
        
        return Auth.auth().currentUser?.uid
    }
    
    var userName: String?
    
    var userEmail: String?
    
    var userPhotoURL: String?
    
    // MARK: Firebase 註冊
    func onClickRegister(userName: String,
                         userEmail: String,
                         userPassword: String,
                         _ handler: @escaping (Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: userEmail,
                               password: userPassword) { (_, error) in
                                
                                handler(error)
        }
    }
    
    // MARK: Firebase 登入
    func onClickLogin(_ userEmail: String,
                      _ userPassword: String,
                      _ handler: @escaping (Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: userEmail,
                           password: userPassword) { (_, error) in
                            
                            handler(error)
        }
    }
    
    // MARK: Firebase 密碼重設
    func onResetPassword(_ userSignInView: UserSignUpView) {
        
        if userSignInView.userEmailTxtFld.text == "" {
            
//            showAlert(belongToVC, "請輸入信箱")
        }
        
        Auth.auth().sendPasswordReset(withEmail: userSignInView.userEmailTxtFld.text ?? "") { (error) in
            
            if error != nil {
                
//                self.showAlert(self.belongToVC, error!.localizedDescription)
                
                return
            }
            
//            self.showAlert(self.belongToVC, "重設成功，請檢查信箱信件")
        }
    }
}
