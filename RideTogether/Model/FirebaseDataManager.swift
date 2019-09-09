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
    func addMemberInGroup(_ groupID: String, _ userUID: String, _ userName: String) {
        
        let groupDocument = Firestore.firestore().collection("group").document(groupID)
                
        groupDocument.getDocument { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                guard
                    let groupName = querySnapshot.data()?["name"] as? String,
                    var member = querySnapshot.data()?["member"] as? [String]
                else { return }
                
                for currentMember in member {
                    
                    while userUID == currentMember {
                        
                        print("已經加入了喔")
                        
                        return
                    }
                }
                
                member.append(userUID)
                
                groupDocument.setData(["name": groupName, "member": member])
                
                groupDocument.collection("member").document(userUID).setData(["name": userName])
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
    
    // 用 uid 搜尋會員 Name
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
                    
                    let groupID = document.documentID
                    
                    // 抓取群組資料
                    self.getDataFromGroup(groupVC, groupID, name, member)
                }
            }
        }
    }
    
    // 監聽新增群組
    func observerOfGroup(_ groupVC: GroupListViewController, _ userID: String, handler: @escaping () -> Void) {
        
        let groupOfUser = Firestore.firestore().collection("group").whereField("member", arrayContains: userID)
        
        groupOfUser.addSnapshotListener { (querySnapshot, _) in
            
            guard let querySnapshot = querySnapshot else { return }
            
            querySnapshot.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added {
                    
                    guard
                        let name = documentChange.document.data()["name"] as? String,
                        let member = documentChange.document.data()["member"] as? [String]
                    else { return }
                    
                    let groupID = documentChange.document.documentID
                    
                    // 抓取群組資料
                    self.getDataFromGroup(groupVC, groupID, name, member)
                }
            })
        }
    }
    
    // 監聽新增成員
    func observerOfMember(_ groupDetailVC: GroupDetailViewController, _ groupID: String) {
        
        let memberOfGroup = Firestore.firestore().collection("group").document(groupID).collection("member")
        
        memberOfGroup.addSnapshotListener { (querySnapshot, _) in
            
            guard let querySnapshot = querySnapshot else { return }
            
            querySnapshot.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added {
                    
                    guard let memberName = documentChange.document.data()["name"] as? String
                    else { return }
                    
                    groupDetailVC.memberInGroup.append(memberName)
                }
            })
        }
    }
    
//    var memberData = [MemberData]()
    
    // 抓取群組資料
    private func getDataFromGroup(_ groupVC: GroupListViewController,
                                  _ groupID: String,
                                  _ name: String,
                                  _ member: [String]) {
        
        let dataInfo = Firestore.firestore().collection("group").document(groupID).collection("member")
        
        dataInfo.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                var memberInfoArray = [MemberInfo]()
                
                for document in querySnapshot.documents {
                    
                    guard
                        let name = document.data()["name"] as? String
                        
                    else { return }
                                        
                    var memberInfo = MemberInfo(memberName: name)
                    
                    memberInfo.route = document.data()["route"] as? [GeoPoint]
                    
                    memberInfo.spendTime = document.data()["spendTime"] as? Int
                    
                    memberInfo.averageSpeed = document.data()["averageSpeed"] as? Double
                    
                    memberInfo.distance = document.data()["distance"] as? Double
                    
                    memberInfo.maximumSpeed = document.data()["maximumSpeed"] as? Double
                    
                    memberInfoArray.append(memberInfo)
                }
                
                let group = GroupInfo(gorupID: groupID,
                                      groupName: name,
                                      groupMember: member,
                                      memberInfo: memberInfoArray)
                
                // 儲存群組資料
                groupVC.groupInfoArray.insert(group, at: 0)
            }
        }
    }
    
    // 上傳使用者所在位置
    func uploadUserLocation(_ groupID: String, _ userUID: String, _ userLoction: [Double]) {
        
        let userInfo = Firestore.firestore().collection("group").document(groupID)
            .collection("member").document(userUID)
        
        let geoPoint = GeoPoint(latitude: userLoction[0], longitude: userLoction[1])
        
        let locationData = ["name": UserInfo.name!, "location": geoPoint] as [String: Any]
        
        userInfo.setData(locationData)
    }
    
    // 監聽同伴所在位置
    func updateMemberLocation(_ ridingViewController: RidingViewController, _ groupID: String) {
        
        let memberLocationData = Firestore.firestore().collection("group").document(groupID).collection("member")
        
        memberLocationData.addSnapshotListener { (querySnapshot, _) in
            
            guard let querySnapshot = querySnapshot else { return }
            
            querySnapshot.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .modified {
                    
                    guard
                        let memberName = documentChange.document.data()["name"] as? String,
                        let memberLocation = documentChange.document.data()["location"] as? GeoPoint
                    else { return }
                    
//                    groupDetailVC.memberInGroup.append(memberName)
                    print(memberName)
                    print(memberLocation)
                }
            })
        }
    }
    
    // 監聽結果
    func observerOfResult(_ ridingResultVC: RidingResultViewController,_ groupID: String) {
        
        let ridingResultData = Firestore.firestore().collection("group").document(groupID).collection("member")
        
        ridingResultData.addSnapshotListener { (querySnapshot, _) in
            
            guard let querySnapshot = querySnapshot else { return }
            
            querySnapshot.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added {
                    
                    self.updateRidingResult(ridingResultVC, groupID)
                }
                
                if documentChange.type == .modified {
                    
                    self.updateRidingResult(ridingResultVC, groupID)
                }
            })
        }
    }
    
    // 更新結果
    
    func updateRidingResult(_ ridingResultVC: RidingResultViewController, _ groupID: String) {
        
        let ridingResultData = Firestore.firestore().collection("group").document(groupID).collection("member").order(by: "spendTime", descending: false)
        
        ridingResultData.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                var ridingResultArray = [MemberInfo]()
                
                for document in querySnapshot.documents {
                    
                    guard
                        let memberName = document.data() ["name"] as? String,
                        let spendTime = document.data() ["spendTime"] as? Int
                    else { return }
                    
                    var memberInfo = MemberInfo(memberName: memberName)
                    
                    memberInfo.spendTime = spendTime
                    
                    ridingResultArray.append(memberInfo)
                }
                
                ridingResultVC.memberResultInfo = ridingResultArray
            }
        }
    }
    
    // 上傳騎乘紀錄
    func uploadRidingData(_ groupID: String, _ userUID: String, _ ridingData: [String: Any]) {
        
        let userInfo = Firestore.firestore().collection("group").document(groupID)
            .collection("member").document(userUID)
        
        userInfo.setData(ridingData)
    }
}
