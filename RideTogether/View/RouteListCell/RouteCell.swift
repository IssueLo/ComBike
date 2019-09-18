//
//  RouteListCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/17.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import MapKit

class RouteCell: UICollectionViewCell {
    
    @IBOutlet weak var routeMapView: MKMapView! {
        
        didSet {
            
            routeMapView.delegate = self
        }
    }
    
    @IBOutlet weak var routeNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addRound(radis: 8)
    }
}

extension RouteCell: MKMapViewDelegate {
    
}
