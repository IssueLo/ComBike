//
//  UserSignInView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/8/30.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

protocol UserSignUpViewDelegate: AnyObject {
    
    func toLogInView()
    
    func userSignUp(userName: String?,
                    userEmail: String?,
                    userPassword: String?,
                    confirmPassword: String?)
}

class UserSignUpView: UIView {
    
    weak var delegate: UserSignUpViewDelegate?
    
    @IBOutlet weak var userNameTxtFld: UITextField! {
        didSet {
            
            userNameTxtFld.placeholder = "請輸入暱稱"
        }
    }
    
    @IBOutlet weak var userEmailTxtFld: UITextField! {
        didSet {
            
            userEmailTxtFld.placeholder = "請輸入 email"
        }
    }
    
    @IBOutlet weak var userPasswordTxtFld: UITextField! {
        didSet {
            
            userPasswordTxtFld.placeholder = "請輸入密碼"
        }
    }
    
    @IBOutlet weak var confirmPasswordTxtFld: UITextField! {
        didSet {
            
            confirmPasswordTxtFld.placeholder = "請再次確認密碼"
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        
        didSet {
            
            signUpButton.layer.cornerRadius = 25
            
            signUpButton.backgroundColor = .hexStringToUIColor()
        }
    }
    
    @IBAction func confirmSignUp() {
        
        delegate?.userSignUp(userName: userNameTxtFld.text,
                             userEmail: userEmailTxtFld.text,
                             userPassword: userPasswordTxtFld.text,
                             confirmPassword: confirmPasswordTxtFld.text)
    }
    
    @IBOutlet weak var toLogInViewBtn: UIButton! {
        
        didSet {
            
            toLogInViewBtn.setTitleColor(.hexStringToUIColor(), for: .normal)
        }
    }
    
    @IBAction func toLogInView() {
        
        delegate?.toLogInView()
    }
}
