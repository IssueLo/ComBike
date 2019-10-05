//
//  GroupListCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var groupImage: UIImageView! {
        
        didSet {
            
            groupImage.addRound(radius: Double(groupImage.bounds.width / 2),
                                borderWidth: 0.7,
                                borderColor: .black)
        }
    }
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
