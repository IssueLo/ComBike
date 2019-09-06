//
//  GroupInfo.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

//import Foundation
import Firebase

struct GroupInfo {
    
    var groupID: String
    
    var name: String
    
    var member: [String]
    
    var memberInfo: [MemberInfo]
    
    init (gorupID: String, groupName: String, groupMember: [String], memberInfo: [MemberInfo]) {
        
        self.groupID = gorupID
        
        self.name = groupName
        
        self.member = groupMember
        
        self.memberInfo = memberInfo
    }
}

struct MemberInfo {
    
    let name: String
    
    var spendTime: Int?
    
    var distance: Double?
    
    var averageSpeed: Double?
    
    var maximumSpeed: Double?
    
    var route: [GeoPoint]?
    
    var location: GeoPoint?
    
    init (memberName: String) {
        
        self.name = memberName
    }
}

struct MemberData {
    
    //    var name: String
    
    var location: GeoPoint
    
    //    var route: [GeoPoint]
    
    //    var spendTime: Int
    
    var averageSpeed: Double
    
    //    var maximumSpeed: Double
    
    var distance: Int
    
    init(_ location: GeoPoint, _ averageSpeed: Double, _ distance: Int) {
        
        self.location = location
        
        self.averageSpeed = averageSpeed
        
        self.distance = distance
        
    }
}
