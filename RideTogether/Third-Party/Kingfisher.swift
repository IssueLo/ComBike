//
//  Kingfisher.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/16.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

//import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(urlString: String) {
        
        let url = URL(string: urlString)
        
        self.kf.setImage(with: url)
    }
}
