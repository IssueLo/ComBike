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
    
    private let service: Keychain
    
    private let userUID: String = "userUID"
    
    private init () {
        
        service = Keychain(service: Bundle.main.bundleIdentifier!)
    }
    
    var token: String? {
        
        set {
    
            service[userUID] = newValue
        }
    
        get {
    
            return service[userUID]
        }
    }
}
