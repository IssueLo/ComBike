//
//  UserInfo.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

enum FirebaseKey: String {
    
    case userInfo
    
    case group
}

enum GroupKey: String {
    
    case groupID
    
    case name
    
    case member
    
    case isFinished
    
    case createTime
}

enum UserInfoKey: String {
    
    case name = "userName"
    
    case email = "userEmail"
    
}
