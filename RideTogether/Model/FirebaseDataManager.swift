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

class FirebaseDataManeger {
    
    static let shared = FirebaseDataManeger()
    
    private init() {}
    
    func searchUserInfo(_ userID: String) {
        
        let uesrInfo = Firestore.firestore().collection("userInfo").document(userID)
        
        uesrInfo.getDocument { (querySnapshot, _) in
                        
            if let querySnapshot = querySnapshot {
                
                print("UserInfo: \(querySnapshot.data() as Any)")
            }
        }
    }
    
    var myGroup = [MyGroup]()
    
    func searchUserGroup(_ userID: String) {
        
        let uesrInfo = Firestore.firestore().collection("group").whereField("member", arrayContains: userID)
        
        uesrInfo.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                for document in querySnapshot.documents {
                    
                    guard
                        let name = document.data()["name"] as? String,
                        let member = document.data()["member"] as? [String]
                        
                    else { return }
                    
                    let group = MyGroup(name: name, member: member)
                    
                    self.myGroup.append(group)
                    
                    self.getDataFromGroup(document.documentID)
                }
                
                print("MyGroup: \(self.myGroup)")
            }
        }
    }
    
    private func getDataFromGroup(_ groupID: String) {
        
        let dataInfo = Firestore.firestore().collection("group").document(groupID).collection("member")
        
        dataInfo.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                for document in querySnapshot.documents {
                    
                    print("GroupData: \(document.data() as Any)")
                }
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
