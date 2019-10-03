//
//  AreaRouteCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/29.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class AreaRouteCell: UICollectionViewCell {
    
    @IBOutlet weak var routeView: UIImageView! {
        
        didSet {
            
//            routeView.addRound(radis: 5, borderWidth: 0)
        }
    }
    
    @IBOutlet weak var routeNameLabel: UILabel! {
        
        didSet {
            
//            routeNameLabel.textColor = .hexStringToUIColor()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        contentView.addRound(radis: 12, borderColor: .white)
    }
}
