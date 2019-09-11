//
//  UserProfileController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/11.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class UserProfileController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            
            userImage.layer.cornerRadius = 64
            
            userImage.layer.borderWidth = 3
            
            userImage.layer.borderColor = UIColor.white.cgColor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
