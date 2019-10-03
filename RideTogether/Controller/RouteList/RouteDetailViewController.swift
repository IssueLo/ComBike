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
    
    @IBOutlet weak var routeMapView: MKMapView! {
        
        didSet {
                
            routeMapView.delegate = self
        }
    }
    
    @IBOutlet weak var routeDetailView: RouteDetailView! {
        
        didSet {
            
            routeDetailView.addRoundOnTop()
            
            routeDetailView.addShadow(offset: CGSize(width: 3, height: -2), opacity: 0.4)
        }
    }
    
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
        
        routeDetailView.setView(routeData: routeData)
        
        let polylineCode = routeData.map.polyline
        
        PolylineManager.shared.mapView = self.routeMapView
        
        PolylineManager.shared.showPolyline(polylineCode: polylineCode)
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
