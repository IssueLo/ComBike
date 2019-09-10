//
//  UserSignInView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/8/30.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class UserSignUpView: UIView {
    
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
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmSignUp() {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
}