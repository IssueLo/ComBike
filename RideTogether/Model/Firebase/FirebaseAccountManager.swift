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
    
    // 這個要拿掉
    var belongToVC: UIViewController!
    
    // MARK: Firebase 註冊
    func onClickRegister(userName: String,
                         userEmail: String,
                         userPassword: String,
                         _ handler: @escaping (Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: userEmail,
                               password: userPassword) { (_, error) in
                                
                                handler(error)
//                                if error != nil {
//                                    
//                                    self.showAlert(self.belongToVC, (error?.localizedDescription)!)
//                                    
//                                    return
//                                }
//                                
//                                self.showAlert(self.belongToVC, "註冊成功，已登入")
//                                
//                                // 會員資料儲存到 Firebase
//                                guard
//                                    let userUID = Auth.auth().currentUser?.uid
//                                    
//                                else { return }
//                                
//                                FirebaseDataManeger.shared.addUserInfo(userUID, userName, userEmail)
//                                
//                                // 暫存資料庫，要換成 keychain
//                                UserInfo.uid = Auth.auth().currentUser?.uid
//                                
//                                UserInfo.name = userName
        }
    }
    
    // MARK: Firebase 登入
    func onClickLogin(_ userEmail: String,
                      _ userPassword: String,
                      _ handler: @escaping (Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: userEmail,
                           password: userPassword) { (_, error) in
                            
//                            KeyChainManager.shard.token = Auth.auth()
                            
                            handler(error)
                            
//                            if error != nil {
//
//                                self.showAlert(self.belongToVC, error!.localizedDescription)
//
//                                return
//                            }
////
//                            self.showAlert(self.belongToVC, "登入成功")
//
//                            UserInfo.uid = Auth.auth().currentUser?.uid
//
//                            guard let userUID = UserInfo.uid else { return }
//
//                            // Firebase 抓取資料
//                            FirebaseDataManeger.shared.searchUserInfo(userUID)
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
            
            UserInfo.uid = Auth.auth().currentUser?.uid
            
            print(Auth.auth().currentUser?.uid as Any)
            
        } catch let error as NSError {
            
            showAlert(belongToVC, error.localizedDescription)
        }
    }
    
    // MARK: Firebase 密碼重設
    func onResetPassword(_ userSignInView: UserSignUpView) {
        
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
