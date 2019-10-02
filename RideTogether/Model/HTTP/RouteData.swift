//
//  File.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/1.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

struct RouteData: Codable {
    
    let routeID: Int
    
    var name: String
    
    let distance: Double
    
    let map: Map
    
    let estimatedTime: Int
    
    let elevationGain: Double
    
    enum CodingKeys: String, CodingKey {
        
        case name, distance, map
        
        case routeID = "id"
        
        case estimatedTime = "estimated_moving_time"
        
        case elevationGain = "elevation_gain"
        
    }
}

struct Map: Codable {
    
    let polyline: String
    
    enum CodingKeys: String, CodingKey {
        
        case polyline = "summary_polyline"
    }
}
