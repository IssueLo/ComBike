//
//  CreatGroupController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class CreateGroupController: UIViewController {
    
    @IBOutlet weak var backView: UIView! {
        didSet {
            
            backView.layer.cornerRadius = 14
        }
    }
    
    @IBOutlet weak var groupNameTxtFld: UITextField! {
        didSet {
            
            groupNameTxtFld.placeholder = "請輸入群組名稱"
        }
    }
    
    @IBAction func createGroup() {
        
        guard let groupName = groupNameTxtFld.text else { return }
        
        if groupName == "" {
            
            self.showAlert("群組名稱不可為空白喔")
            
        } else {
        
            FirebaseDataManeger.shared.createGroup(groupName) { (message) in
                
                self.showAlert(message, { (_) in
                    
                    self.dismiss(animated: false, completion: nil)
                })
            }
        }
        
//        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func backGroupVC() {
        
        dismiss(animated: false, completion: nil)
        
//        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
