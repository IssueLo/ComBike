//
//  Poltline.swift
//  StravaAPITest
//
//  Created by 戴汝羽 on 2019/8/29.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Polyline
import MapKit
import Firebase

class PolylineManager {
    
    static var shared = PolylineManager()
    
    var mapView: MKMapView?
    
    private init() {}
    
    // 增加路線圖到地圖上
    func showPolyline(coordinates: [CLLocationCoordinate2D]) {
        
        let geodesic = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
        
        self.mapView?.addOverlay(geodesic)
    }
    
    // 讓畫面以路線為中心
    func showPolyline(polylineCode: String) {
        
        let polyline = Polyline(encodedPolyline: polylineCode)
        
        guard
            let coordinates: [CLLocationCoordinate2D] = polyline.coordinates
        else { return }
        
        let geodesic = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
        
        self.mapView?.addOverlay(geodesic)
        
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            
            guard let mkPolyline = polyline.mkPolyline else { return }
            
            var regionRect = mkPolyline.boundingMapRect
            let wPadding = regionRect.size.width * 0.3
            let hPadding = regionRect.size.height * 0.3
            
            regionRect.size.width += wPadding
            regionRect.size.height += hPadding
            
            regionRect.origin.x -= wPadding / 2
            regionRect.origin.y -= hPadding / 2
            
            self.mapView?.setRegion(MKCoordinateRegion(regionRect), animated: true)
        })
    }

    func decodePolyline(_ polylineCode: String) -> [CLLocationCoordinate2D] {
        
        let polyline = Polyline(encodedPolyline: polylineCode)
        
        let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
        
        return decodedCoordinates ?? []
        
    }
    
    func encodePolyline(_ coordinates: [CLLocationCoordinate2D]) -> String {
        
        let polyline = Polyline(coordinates: coordinates)
        
        let encodedPolyline: String = polyline.encodedPolyline
        
        return encodedPolyline
    }
    
/*
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }
*/
    
/*
    let annotation = MKPointAnnotation()
    annotation.coordinate = points[location]
    annotation.title = "Kevin"
    mapView.addAnnotation(annotation)
*/
    
}
