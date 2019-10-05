//
//  RidingResultCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RidingResultCell: UITableViewCell {
    
    @IBOutlet weak var memberImage: UIImageView! {
        
        didSet {
            
            memberImage.addRound(radius: Double(memberImage.bounds.width / 2),
                                 borderWidth: 0.7,
                                 borderColor: .gray)
        }
    }
    
    @IBOutlet weak var memberNameLabel: UILabel!
    
    @IBOutlet weak var rankingLabel: UILabel!
    
    @IBOutlet weak var spendTimeLabel: UILabel!
    
}
