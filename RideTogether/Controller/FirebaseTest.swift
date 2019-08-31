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
                
                print(querySnapshot.data() as Any)
            }
        }
    }
    
    var myGroup = [MyGroup]()
    
    func searchUserGroup(_ id: String) {
        
        let uesrInfo = Firestore.firestore().collection("group").whereField("member", arrayContains: id)
        
        uesrInfo.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                for document in querySnapshot.documents {
                    
                    guard
                        let name = document.data()["name"] as? String,
                        let member = document.data()["member"] as? [String]
                        
                    else { return }
                    
                    let group = MyGroup(name: name, member: member)
                    
                    self.myGroup.append(group)
                }
                
                print(self.myGroup)
            }
        }
    }
}

struct MyGroup {

    var name: String
    
    var member: [String]
    
    init (name: String, member: [String]) {
        
        self.name = name
        
        self.member = member
    }
}
