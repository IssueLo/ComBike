//
//  KeyChainManager.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import KeychainAccess

class KeyChainManager {
    
    static let shard = KeyChainManager()
    
    private init () {}
    
    var token: String?
}
