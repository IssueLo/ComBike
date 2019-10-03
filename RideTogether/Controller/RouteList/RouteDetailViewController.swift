//
//  RouteDetailViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/19.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailViewController: UIViewController {
    
    var routeData: RouteData!
    
    @IBOutlet weak var routeImageView: UIImageView!
    
    @IBOutlet weak var routeMapView: MKMapView! {
        
        didSet {
                
            routeMapView.delegate = self
        }
    }
    
    @IBOutlet weak var mapBackView: UIView! {
        
        didSet {
            
            mapBackView.addRoundOnTop()
            
            mapBackView.addShadow(offset: CGSize(width: 3, height: -2), opacity: 0.4)
        }
    }
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var elevationLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var aveAlopeLabel: UILabel!
    
    @IBAction func backLastPage() {
        
        navigationController?.popViewController(animated: true)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        setupInform()
    }
    
    func setupInform() {
        
        let polylineCode = routeData.map.polyline
        
        PolylineManager.shared.mapView = self.routeMapView
        
        PolylineManager.shared.showPolyline(polylineCode: polylineCode)
        
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

extension RouteDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = .hexStringToUIColor()
        
        renderer.lineWidth = 5.0
        
        return renderer
    }
}
