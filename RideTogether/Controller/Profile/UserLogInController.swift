//
//  ViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/8/27.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import FirebaseAuth
import AuthenticationServices

class UserLogInController: UIViewController {
    
    var toNextVCHandler: ((UIAlertAction) -> Void)!
    
    @IBOutlet weak var backCoverView: UIView! {
        
        didSet {
            
            backCoverView.backgroundColor = UIColor.hexStringToUIColor()
        }
    }
        
    @IBOutlet weak var userSignUpView: UserSignUpView!
    
    @IBOutlet weak var userLogInView: UserLogInView!
    
    @IBOutlet weak var toPrivacyWVBtn: UIButton! {
        
        didSet {
            
            toPrivacyWVBtn.addTarget(self,
                                     action: #selector(toPrivacyWebView),
                                     for: .touchUpInside)
        }
    }

    @IBAction func backToLastVC() {
        
//        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLogInView.delegate = self
        
        userSignUpView.delegate = self
        
        setupView()
    }
    
    @objc
    func toPrivacyWebView() {
        
        let webViewStoryboard = UIStoryboard(name: "PrivacyWebStoryboard", bundle: nil)
        
        let webViewVC = webViewStoryboard.instantiateViewController(identifier: "PrivacyWebController")
        
        present(webViewVC, animated: true, completion: nil)
    }
    
    // MARK: Firebase 密碼重設
    @objc
    func onResetPassword() {
        
    }
}

extension UserLogInController: UserLogInViewDelegate {
    
    func toSignUpView() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.userLogInView.alpha = 0
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
                
                UserDefaults.standard.setValue(userUID, forKey: "UserUID")
                
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
                
                UserDefaults.standard.setValue(userUID, forKey: "UserUID")
                
                FirebaseDataManeger.shared.addUserInfo(userUID, userName!, userEmail!)
                
                FirebaseAccountManager.shared.userName = userName
                                                            
                FirebaseAccountManager.shared.userEmail = userEmail
            }
        }
    }
}

// MARK: Apple SignIn
extension UserLogInController {
    
    func setupView() {
            
        let appleButton = ASAuthorizationAppleIDButton()
        
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)

        userLogInView.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.topAnchor.constraint(equalTo: userLogInView.logInButton.bottomAnchor, constant: 8),
            appleButton.leadingAnchor.constraint(equalTo: userLogInView.logInButton.leadingAnchor),
            appleButton.trailingAnchor.constraint(equalTo: userLogInView.logInButton.trailingAnchor)
            ])
    }
    
    @objc
    func didTapAppleButton() {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
}

extension UserLogInController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = User(credentials: credentials)
            print(user)
                                    
            UserDefaults.standard.setValue(user.id, forKey: "UserUID")
            
            // 登入成功後取得會員暱稱
            FirebaseDataManeger.shared.searchUserInfo(user.id)
            
            FirebaseAccountManager.shared.userEmail = user.email
            
            FirebaseDataManeger.shared.appleSignIn(user.id,
                                                   user.firstName,
                                                   user.email)
            
            showAlert("登入成功", self.toNextVCHandler)

        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("something bad happened", error)
    }
}

extension UserLogInController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return view.window!
    }
}
