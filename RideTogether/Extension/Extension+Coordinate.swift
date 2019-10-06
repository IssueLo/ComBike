//
//  Extension+Coordinate.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/9.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import MapKit
import Firebase

extension CLLocationCoordinate2D {
    
    func transferToGeopoint() -> GeoPoint {
        
        let geoPoint = GeoPoint(latitude: self.latitude,
                                longitude: self.longitude)
        
        return geoPoint
    }
}

extension GeoPoint {
    
    func transferToCoordinate2D() -> CLLocationCoordinate2D {
        
        let coordinate2D = CLLocationCoordinate2D(latitude: self.latitude,
                                                  longitude: self.longitude)
        
        return coordinate2D
    }
}
