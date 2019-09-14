//
//  GroupData.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/14.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation
import Firebase

struct GroupData {
    
    var groupID: String
    
    var name: String
    
    var member: [String]
        
    var isFinished = false
    
    var createTime: Timestamp
}
