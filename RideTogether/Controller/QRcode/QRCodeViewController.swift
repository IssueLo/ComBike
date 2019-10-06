//
//  QRCodeViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    var groupID: String!
    
    @IBOutlet weak var qrCodeView: QRCodeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        qrCodeView.backAction {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.dismiss(animated: false, completion: nil)
            })
        }
        
        qrCodeView.setQRcode(makeQRCodeImage(groupID))
    }
    
    func makeQRCodeImage(_ groupID: String) -> UIImage? {
        
        return QRCodeMaker.generateQRCode(from: groupID) ?? nil
    }
}
