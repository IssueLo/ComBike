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
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userRankLabel: UILabel!
    
    @IBOutlet weak var userSubRankLabel: UILabel!
    
    @IBOutlet weak var userSpendTimeLabel: UILabel!
    
    var handler: (() -> Void)!
    
    @IBAction func backToGroupList() {
        
        handler()
    }
    
    func setupHeaderView(_ groupName: String,
                         _ userName: String,
                         _ userRank: Int,
                         _ userSubRank: String,
                         _ userSpendtime: String) {
        
        groupNameLabel.text = groupName
        
        userNameLabel.text = userName
        
        userRankLabel.text = String(userRank)
        
        userSubRankLabel.text = userSubRank
        
        userSpendTimeLabel.text = userSpendtime
    }
    
}
