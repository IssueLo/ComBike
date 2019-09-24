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
    
    let uid: String
    
    let name: String
    
    var photoURLString: String?
        
    var spendTime: Int?
    
    var distance: Double?
    
    var averageSpeed: Double?
    
    var maximumSpeed: Double?
    
    var route: [GeoPoint]?
    
    var location: GeoPoint?
    
    var altitude: [Double]?
    
    init (memberName: String, memberNameUID: String) {
        
        self.name = memberName
        
        self.uid = memberNameUID
    }
}

struct LocationOfMember {
    
    var name: String
    
    var location: CLLocationCoordinate2D
}
