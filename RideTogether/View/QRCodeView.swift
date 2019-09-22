//
//  QRCodeView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class QRCodeView: UIView {
    
    var handler: (() -> Void)?
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    @IBOutlet weak var qrCodeBackView: UIView! {
        
        didSet {
            
            qrCodeBackView.addRound(radis: 8)
        }
    }
    
    @IBAction func backGroupDeteilVC() {
        
        guard let handler = handler else { return }
        
        handler()
    }
    
    func setQRcode(_ qrCodeImage: UIImage?) {
        
        self.qrCodeImage.image = qrCodeImage
    }
    
    func backAction(_ handler: @escaping () -> Void) {
        
        self.handler = handler
    }
}
