//
//  GroupListHeaderView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupListHeaderView: UITableViewHeaderFooterView {

    var sectionControlHandler: (() -> Void)?
    
    @IBOutlet weak var createDateLabel: UILabel!
    
    @IBOutlet weak var sectionControlBtn: UIButton! {
        
        didSet {
            
            sectionControlBtn.isHidden = true
            
            sectionControlBtn.addTarget(self,
                                        action: #selector(sectionHeightControl),
                                        for: .touchUpInside)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = .white
    }
    
    @objc
    func sectionHeightControl() {
        
        sectionControlHandler?()
    }
    
}
