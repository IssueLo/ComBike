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
            
            backView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var groupImageView: UIImageView! {
        
        didSet {
            
            groupImageView.addRound(radius: Double(groupImageView.bounds.width / 2),
                                    borderWidth: 0.8,
                                    borderColor: .black)
        }
    }

    @IBOutlet weak var groupNameTxtFld: UITextField! {
       
        didSet {
            
            groupNameTxtFld.placeholder = "請輸入群組名稱"
        }
    }
    
    @IBOutlet weak var createGroupBtn: UIButton! {
        
        didSet {

            createGroupBtn.addRound(radius: 16,
                                    backgroundColor: .hexStringToUIColor())
            
            createGroupBtn.setTitleColor(.white, for: .normal)
            
            createGroupBtn.addTarget(self,
                                     action: #selector(createGroup),
                                     for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var backGroupVCBtn: UIButton! {
        
        didSet {
            
//            backGroupVCBtn.imageView?.contentMode = .scaleAspectFit
//            
//            backGroupVCBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            backGroupVCBtn.addTarget(self,
                                     action: #selector(backGroupVC),
                                     for: .touchUpInside)
        }
    }
    
    @objc
    func createGroup() {
        
        guard let groupName = groupNameTxtFld.text else { return }
        
        if groupName == "" {
            
            self.showAlert("群組名稱不可為空白喔")
            
        } else {
        
            FirebaseDataManager.shared.createGroup(groupName) { [weak self](message) in
                
                self?.showAlert(message, { (_) in
                    
                    self?.dismiss(animated: false)
                })
            }
        }
    }
    
    @objc
    func backGroupVC() {
        
        dismiss(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
