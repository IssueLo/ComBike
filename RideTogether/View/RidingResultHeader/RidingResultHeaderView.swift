//
//  RidingResultHeader.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/8.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RidingResultHeaderView: UIView {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    var handler: (() -> Void)!
    
    @IBAction func backToGroupList() {
        
        handler()
    }
    
    func setupHeaderView(_ groupName: String) {
        
        groupNameLabel.text = groupName
    }
}
