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
    
    // 新加入會員資料
    func addUserInfo(_ userUID: String,
                     _ userName: String,
                     _ userEmail: String) {
        
        let userInfoCollection = Firestore.firestore().collection("userInfo")
        
        let userInfo: [String: Any] = ["userName": userName, "userEmail": userEmail]
        
        userInfoCollection.document(userUID).setData(userInfo)
    }
    
    // 建立群組
    func createGroup(_ groupName: String) {
        
        let groupCollection = Firestore.firestore().collection("group")
        
        groupCollection.document().setData(["name": groupName, "member": []])
        
        print(groupCollection.document().documentID)
    }
    
    // 編輯群組 - 增加成員
    func addMemberInGroup(_ groupID: String, _ userID: String) {
        
        let groupDocument = Firestore.firestore().collection("group").document(groupID)
                
        groupDocument.getDocument { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                guard
                    let name = querySnapshot.data()?["name"] as? String,
                    var member = querySnapshot.data()?["member"] as? [String]
                else { return }
                
                member.append(userID)
                
                groupDocument.setData(["name": name, "member": member])
            }
        }
    }
    
    // 編輯群組 - 更改群組名稱
    func modifyGroupName(_ groupID: String, _ groupName: String) {
        
        let groupDocument = Firestore.firestore().collection("group").document(groupID)
        
        groupDocument.getDocument { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                guard
                    let member = querySnapshot.data()?["member"] as? [String]
                else { return }
                
                groupDocument.setData(["name": groupName, "member": member])
            }
        }
    }
    
    // 測試用：搜尋會員
    func searchUserInfo(_ userID: String) {
        
        let uesrInfoDocument = Firestore.firestore().collection("userInfo").document(userID)
        
        uesrInfoDocument.getDocument { (querySnapshot, _) in
                        
            if let querySnapshot = querySnapshot {
                
                print("UserInfo: \(querySnapshot.data() as Any)")
            }
        }
    }
    
    var myGroup = [MyGroup]()
    
    // 搜尋會員所屬群組
    func searchUserGroup(_ userID: String) {
        
        let uesrInfo = Firestore.firestore().collection("group").whereField("member", arrayContains: userID)
        
        uesrInfo.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                for document in querySnapshot.documents {
                    
                    guard
                        let name = document.data()["name"] as? String,
                        let member = document.data()["member"] as? [String]
                        
                    else { return }
                    
                    let group = MyGroup(groupName: name, groupMember: member)
                    
                    self.myGroup.append(group)
                    
                    // 抓取群組資料
                    self.getDataFromGroup(document.documentID)
                }
                
                print("MyGroup: \(self.myGroup)")
            }
        }
    }
    
    var memberData = [MemberData]()
    
    // 抓取群組資料
    private func getDataFromGroup(_ groupID: String) {
        
        let dataInfo = Firestore.firestore().collection("group").document(groupID).collection("member")
        
        dataInfo.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                for document in querySnapshot.documents {
                    
                    guard
                        let location = document.data()["location"] as? GeoPoint,
                        let averageSpeed = document.data()["averageSpeed"] as? Double,
                        let distance = document.data()["distance"] as? Int
                    else { return }
                    
                    let memberData = MemberData(location, averageSpeed, distance)
                    
                    print(memberData)
//                    print("GroupData: \(document.data() as Any)")
                }
            }
        }
    }
}

struct MyGroup {

    var name: String
    
    var member: [String]
    
    init (groupName: String, groupMember: [String]) {
        
        self.name = groupName
        
        self.member = groupMember
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

//struct UserInfo {
//
//    var name: String
//
//    var email: String
//
//    init (userName: String, userEmail: String) {
//
//        self.name = userName
//
//        self.email = userEmail
//    }
//}
