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
            
            memberImage.addRound(radis: Double(memberImage.bounds.width / 2))
        }
    }
    
    @IBOutlet weak var memberNameLabel: UILabel!
    
    @IBOutlet weak var rankingLabel: UILabel!
    
    @IBOutlet weak var spendTimeLebal: UILabel!
    
}
