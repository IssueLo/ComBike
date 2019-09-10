//
//  UserLoginIn.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/10.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

protocol UserLogInViewDelegate: AnyObject {
    
    func userLogIn(userEmail: String?, userPassword: String?)
}

class UserLogInView: UIView, UITextFieldDelegate {
        
    var toSignUpViewHandler: (() -> Void)!
    
    weak var delegate: UserLogInViewDelegate?
    
    @IBOutlet weak var userEmailTxtFld: UITextField! {
        didSet {
            
            userEmailTxtFld.placeholder = "請輸入 email"
            
            userEmailTxtFld.delegate = self
        }
    }
    
    @IBOutlet weak var userPasswordTxtFld: UITextField! {
        didSet {
            
            userPasswordTxtFld.placeholder = "請輸入密碼"
            
            userPasswordTxtFld.delegate = self
        }
    }
    
    @IBOutlet weak var logInButton: UIButton! {
        
        didSet {
            
            logInButton.layer.cornerRadius = 25
        }
    }
        
    @IBAction func confirmLogIn() {
        
        delegate?.userLogIn(userEmail: userEmailTxtFld.text,
                            userPassword: userPasswordTxtFld.text)
    }
    
    @IBAction func toSignUpView() {
        
        toSignUpViewHandler()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
