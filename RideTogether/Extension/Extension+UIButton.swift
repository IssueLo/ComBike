//
//  Extansion+UIButton.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/12.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

extension UIButton {
    
    func addRound(radis: Double, borderColor: UIColor, backgroundColor: UIColor) {
        
        self.layer.cornerRadius = CGFloat(radis)
        
        self.layer.borderWidth = 1
        
        self.layer.borderColor = borderColor.cgColor
        
        self.backgroundColor = backgroundColor
    }
}
