//
//  CreatGroupController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class CreateGroupController: UIViewController {
    
    @IBOutlet weak var groupNameTxtFld: UITextField! {
        didSet {
            
            groupNameTxtFld.placeholder = "請輸入群組名稱"
        }
    }
    
    @IBAction func createGroup() {
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func backGroupVC() {
        
        dismiss(animated: false, completion: nil)
        
//        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
