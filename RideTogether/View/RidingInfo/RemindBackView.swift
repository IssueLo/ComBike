//
//  RemindBackView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

protocol RemindBackViewDelegate: AnyObject {
    
    func createGroup()
}

class RemindBackView: UIView {
    
    weak var delegate: RemindBackViewDelegate?
    
    @IBOutlet weak var remindLabel: UILabel!
    
    @IBOutlet weak var createGroupBtn: UIButton! {
        
        didSet {
            
            createGroupBtn.addRound(backgroundColor: .hexStringToUIColor())
            
            createGroupBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func createGroup(_ sender: UIButton) {
        
        delegate?.createGroup()
    }
}
