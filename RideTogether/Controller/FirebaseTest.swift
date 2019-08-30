//
//  FirebaseTest.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/8/30.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FirebaseController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchUserInfo("igUfN5KSRrROF16SdoNJ")
    }
    
    func searchUserInfo(_ id: String) {
        
        let uesrInfo = Firestore.firestore().collection("userInfo").document(id)
        
        uesrInfo.getDocument { (querySnapshot, _) in
                        
            if let querySnapshot = querySnapshot {
                
                print(querySnapshot)
            }
        }
    }
    
}
