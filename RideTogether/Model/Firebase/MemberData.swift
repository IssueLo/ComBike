//
//  MemberData.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/14.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import FirebaseFirestore
import MapKit

struct MemberData {
    
    let name: String
    
    var spendTime: Int?
    
    var distance: Double?
    
    var averageSpeed: Double?
    
    var maximumSpeed: Double?
    
    var route: [GeoPoint]?
    
    var location: GeoPoint?
    
    var altitude: [Double]?
    
    init (memberName: String) {
        
        self.name = memberName
    }
}

struct LocationOfMember {
    
    var name: String
    
    var location: CLLocationCoordinate2D
}
