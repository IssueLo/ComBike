//
//  Extansion+UIButton.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/12.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

extension UIView {
    
    func addRound(radis: Double = 25,
                  borderColor: UIColor = .lightGray,
                  backgroundColor: UIColor = .white) {
        
        self.layer.cornerRadius = CGFloat(radis)
        
        self.layer.borderWidth = 1
        
        self.layer.borderColor = borderColor.cgColor
        
        self.backgroundColor = backgroundColor
    }
    
    func addShadow() {
        
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        
        self.layer.shadowOpacity = 0.7
        
        self.layer.shadowRadius = 3
        
        self.layer.shadowColor = UIColor(red: 44.0/255.0,
                                         green: 62.0/255.0,
                                         blue: 80.0/255.0,
                                         alpha: 1.0).cgColor
    }
}
