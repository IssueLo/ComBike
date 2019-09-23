//
//  Extansion+UIButton.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/12.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

extension UIView {
    
    func addRound(radis: Double = 27,
                  borderWidth: Double = 0,
                  borderColor: UIColor = .lightGray,
                  backgroundColor: UIColor = .white) {
        
        self.layer.cornerRadius = CGFloat(radis)
        
        self.layer.borderWidth = CGFloat(borderWidth)
        
        self.layer.borderColor = borderColor.cgColor
        
        self.backgroundColor = backgroundColor
    }
    
    func addRoundOnTop(radis: Double = 15,
                       borderWidth: Double = 0,
                       borderColor: UIColor = .lightGray,
                       backgroundColor: UIColor = .white) {
        
        self.layer.cornerRadius = CGFloat(radis)
        
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.layer.borderWidth = CGFloat(borderWidth)
        
        self.layer.borderColor = borderColor.cgColor
        
        self.backgroundColor = backgroundColor
    }
    
    func addShadow() {
        
        self.layer.shadowOffset = CGSize(width: 3, height: -2)
        
        self.layer.shadowOpacity = 0.4
        
        self.layer.shadowRadius = 3
        
        self.layer.shadowColor = UIColor(red: 44.0/255.0,
                                         green: 62.0/255.0,
                                         blue: 80.0/255.0,
                                         alpha: 1.0).cgColor
    }
    
//    func caGradientLayer() {
//
//        let grandientLayer = CAGradientLayer()
//
//        grandientLayer.frame = uiView.bounds
//
//        grandientLayer.colors = [UIColor.white.cgColor //UIColor.red.cgColor
//                                             ,UIColor(red: 255, green: 126, blue: 121, alpha: 0).cgColor]
//
//        grandientLayer.startPoint = CGPoint(x: 0, y: 0)
//
//        grandientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//
//        uiView.layer.insertSublayer(grandientLayer, at: 0)
//    }
}
