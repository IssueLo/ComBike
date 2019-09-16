//
//  Extension+UIImage.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/16.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

extension UIImage {

    //等比率缩放
    func scaleImage(scaleSize: CGFloat) -> UIImage {
        
        let reSize = CGSize(width: self.size.width * scaleSize,
                            height: self.size.height * scaleSize)
        
        return reSizeImage(reSize: reSize)
    }
    
    // 重设图片大小
    func reSizeImage(reSize: CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize, false, UIScreen.main.scale)
        
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
        
        let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return reSizeImage
    }
}
