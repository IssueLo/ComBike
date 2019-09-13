//
//  UserInfo.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

class UserInfo {
    
//    static let shared = UserInfo()
//
//    private init() {}
    
//    static var uid: String?
    
//    static var name: String?
}

enum UserInfoKey: String {
    
    case name = "userName"
    
    case email = "userEmail"
    
}

enum GroupKey: String {
    
    case name
    
    case member
    
    case createTime
}

enum FirebaseKey: String {
    
    case userInfo
    
    case group
}
