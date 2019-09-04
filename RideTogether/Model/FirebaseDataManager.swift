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
        
        let groupID = groupCollection.document().documentID
        
        guard
            let userUID = UserInfo.uid,
            let userName = UserInfo.name
        else { return }
        
        groupCollection.document(groupID).setData(["name": groupName, "member": [userUID]])
        
        groupCollection.document(groupID).collection("member").document(userUID).setData(["name": userName])
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
                
                UserInfo.name = querySnapshot.data()?["userName"] as? String
            }
        }
    }
    
    // 搜尋會員所屬群組
    func searchUserGroup(_ groupVC: GroupListViewController, _ userID: String) {
        
        let uesrInfo = Firestore.firestore().collection("group").whereField("member", arrayContains: userID)
        
        uesrInfo.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                for document in querySnapshot.documents {
                    
                    guard
                        let name = document.data()["name"] as? String,
                        let member = document.data()["member"] as? [String]
                    else { return }
                    
                    // 抓取群組資料
                    self.getDataFromGroup(document.documentID, name, member, groupVC)
                }
            }
        }
    }
    
    var memberData = [MemberData]()
    
    // 抓取群組資料
    private func getDataFromGroup(_ groupID: String,
                                  _ name: String,
                                  _ member: [String],
                                  _ groupVC: GroupListViewController) {
        
        let dataInfo = Firestore.firestore().collection("group").document(groupID).collection("member")
        
        dataInfo.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                var memberInfoArray = [MemberInfo]()
                
                for document in querySnapshot.documents {
                    
                    guard
                        let name = document.data()["name"] as? String
//                        let location = document.data()["location"] as? GeoPoint,
//                        let averageSpeed = document.data()["averageSpeed"] as? Double,
//                        let distance = document.data()["distance"] as? Int
                    else { return }
                    
                    let memberInfo = MemberInfo(memberName: name)
                    
                    memberInfoArray.append(memberInfo)
                }
                
                let group = GroupInfo(groupName: name, groupMember: member, memberInfo: memberInfoArray)
                
                groupVC.groupInfoArray.append(group)
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
