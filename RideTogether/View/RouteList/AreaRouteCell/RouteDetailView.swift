//
//  RouteDetailView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RouteDetailView: UIView {

    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var routeImageView: UIImageView!

    @IBOutlet weak var elevationLabel: UILabel!

    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var aveAlopeLabel: UILabel!
    
    func setView(routeData: RouteData) {
        
        let urlString = "https://bike100.tw/wp-content/uploads/\(routeData.routeID).jpg"
        
        let aveAlope: Double = {
            
            return (routeData.distance / 1000) / (routeData.elevationGain / 100)
        }()
        
        locationLabel.text = routeData.name
        
        routeImageView.setImage(urlString: urlString)
                
        distanceLabel.text = String(format: "%.2f", (routeData.distance) * 2 / 1000) + " km"
        
        elevationLabel.text = String(format: "%.2f", routeData.elevationGain) + " m"
        
        aveAlopeLabel.text = String(format: "%.1f", aveAlope) + " %"
    }
}
