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
import MapKit

typealias GroupDataHandler = (Result<GroupData>) -> Void

typealias MemberDataHandler = (Result<MemberData>) -> Void


class FirebaseDataManeger {
    
    static let shared = FirebaseDataManeger()
    
    private init() {}
    
//    var handler: (() -> Void)?
    
    let database = Firestore.firestore()
    
    let userInfoDatebase = Firestore.firestore().collection(FirebaseKey.userInfo.rawValue)
    
    let groupDatebase = Firestore.firestore().collection(FirebaseKey.group.rawValue)
    
    func test() {
        
//        let database = Firestore.firestore()
        
        let reference = userInfoDatebase.document("v5Wsiqy7bFhGMUhaeybw4Cmkvrm1")
        
        database.runTransaction({ (transaction, errorPointer) -> Any? in
            
            let myDocument: DocumentSnapshot
            
            do {
                
                try myDocument = transaction.getDocument(reference)
                
            } catch let fetchError as NSError {
                
                return nil
            }
            
            guard var oldarray = myDocument.data()?["userName"] as? [String] else {
                
                return nil
            }
            
            oldarray.append("oo")
            
            transaction.updateData(["user": oldarray], forDocument: reference)
           
            return nil

        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
        
    }
    
    // deleteAllGroup
    func deleteGorup(_ documentID: String) {
        
        let groupOfUser = groupDatebase.document(documentID)

        groupOfUser.delete()
    }
    
    // Group 監聽
    // 監聽跟排序無法同時設置
    func observerForGroupData(_ userID: String, completion: @escaping (Result<GroupData>) -> Void) {
        
        let groupOfUser = groupDatebase.whereField(GroupKey.member.rawValue, arrayContains: userID)
//            .order(by: GroupKey.createTime.rawValue, descending: true)
        
        groupOfUser.addSnapshotListener { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
               
                return
            }
            
            querySnapshot.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added {
                    
                    guard
                        let name = documentChange.document.data()["name"] as? String,
                        let member = documentChange.document.data()["member"] as? [String],
                        let isFinished = documentChange.document.data()["isFinished"] as? Bool,
                        let createTime = documentChange.document.data()["createTime"] as? Timestamp
                    else { return }
                    
                    let groupID = documentChange.document.documentID
                    
                    let groupData = GroupData(groupID: groupID,
                                              name: name,
                                              member: member,
                                              isFinished: isFinished,
                                              createTime: createTime)
                    
                    completion(Result.success(groupData))
                }
                
                // 旅程完成/ 群組名稱修改
                if documentChange.type == .modified {
                    
                    guard
                        let name = documentChange.document.data()["name"] as? String,
                        let member = documentChange.document.data()["member"] as? [String],
                        let isFinished = documentChange.document.data()["isFinished"] as? Bool,
                        let createTime = documentChange.document.data()["createTime"] as? Timestamp
                        else { return }
                    
                    let groupID = documentChange.document.documentID
                    
                    let groupData = GroupData(groupID: groupID,
                                              name: name,
                                              member: member,
                                              isFinished: isFinished,
                                              createTime: createTime)
                    
                    completion(Result.success(groupData))
                }
            })
            
            guard error == nil else {
                
                return completion(Result.failure(error!))
            }
        }
    }
    
    // Member 監聽
    func observerForMemberData(_ groupID: String, completion: @escaping (Result<MemberData>) -> Void) {
        
        let memberOfGroup = database.collection(FirebaseKey.group.rawValue).document(groupID).collection(GroupKey.member.rawValue)
        
        memberOfGroup.addSnapshotListener { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot else {
                
                return
            }
            
            querySnapshot.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added {
                    
                    guard let name = documentChange.document.data()["name"] as? String
                        else { return }
                    
                    let memberData = MemberData(memberName: name)
                    
                    return completion(Result.success(memberData))
                }
                
                if documentChange.type == .removed {
                    
                    guard let name = documentChange.document.data()["name"] as? String
                        else { return }
                    
                    let memberData = MemberData(memberName: name)
                    
                    return completion(Result.success(memberData))
                }
            })
            
            guard error == nil else {
                
                return completion(Result.failure(error!))
            }
        }
        
    }

    
    // 新加入會員資料 - Done
    func addUserInfo(_ userUID: String,
                     _ userName: String,
                     _ userEmail: String) {
        
        let userInfoCollection = Firestore.firestore().collection(FirebaseKey.userInfo.rawValue)
        
        let userInfoData: [String: Any] = [UserInfoKey.name.rawValue: userName,
                                           UserInfoKey.email.rawValue: userEmail]
        
        userInfoCollection.document(userUID).setData(userInfoData)
    }
    
    // 建立群組 - Done
    func createGroup(_ groupName: String) {
        
        let groupCollection = Firestore.firestore().collection(FirebaseKey.group.rawValue)
        
        // 要打兩次 API，所以要知道 groupID
        let groupID = groupCollection.document().documentID
        
        guard
            let userUID = FirebaseAccountManager.shared.userUID,
            let userName = FirebaseAccountManager.shared.userName
        else { return }
        
        let createTime = Timestamp()
        
        print("createTime: \(createTime)")
        
        groupCollection.document(groupID).setData([GroupKey.name.rawValue: groupName,
                                                   GroupKey.member.rawValue: [userUID],
                                                   GroupKey.isFinished.rawValue: false,
                                                   GroupKey.createTime.rawValue: createTime])
        
        groupCollection.document("\(groupID)/\(GroupKey.member.rawValue)/\(userUID)")
            .setData([GroupKey.name.rawValue: userName])

    }
    
    // 編輯群組 - 增加成員
    func addMemberInGroup(_ groupID: String, _ userUID: String, _ userName: String) {
        
        let groupDocument = Firestore.firestore().collection(FirebaseKey.group.rawValue).document(groupID)
                
        groupDocument.getDocument { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                guard
                    let groupName = querySnapshot.data()?[GroupKey.name.rawValue] as? String,
                    var member = querySnapshot.data()?[GroupKey.member.rawValue] as? [String]
                else { return }
                
                for currentMember in member {
                    
                    while userUID == currentMember {
                        
                        print("已經加入了喔")
                        
                        return
                    }
                }
                
                member.append(userUID)
                
                groupDocument.setData([GroupKey.name.rawValue: groupName,
                                       GroupKey.member.rawValue: member])
                
                groupDocument.collection(GroupKey.member.rawValue).document(userUID).setData([GroupKey.name.rawValue: userName])
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
        
        let uesrInfoDocument = Firestore.firestore().collection(FirebaseKey.userInfo.rawValue).document(userID)
        
        uesrInfoDocument.getDocument { (querySnapshot, _) in
                        
            if let querySnapshot = querySnapshot {
                
                FirebaseAccountManager.shared.userName = querySnapshot.data()?[UserInfoKey.name.rawValue] as? String
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
    
    // 監聽新增群組 - 待刪除
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
        
        let memberOfGroup = Firestore.firestore().collection("group/\(groupID)/member")

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
        
    // 抓取群組資料
    private func getDataFromGroup(_ groupVC: GroupListViewController,
                                  _ groupID: String,
                                  _ name: String,
                                  _ member: [String]) {
        
        let dataInfo = Firestore.firestore().collection("group/\(groupID)/member")
        
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
//                groupVC.groupInfoArray.insert(group, at: 0)
            }
        }
    }
    
    // 上傳使用者所在位置
    func uploadUserLocation(_ groupID: String, _ userUID: String, _ userLoction: CLLocationCoordinate2D) {
        
        let userInfo = Firestore.firestore().collection("group/\(groupID)/member").document(userUID)
        
        let geoPoint = userLoction.transferToGeopoint()
        
        let locationData = ["name": FirebaseAccountManager.shared.userName!, "location": geoPoint] as [String: Any]
        
        userInfo.setData(locationData)
    }
    
    // 監聽同伴所在位置
    func observerOfMemberLocation(_ ridingViewController: RidingViewController, _ groupID: String) {
        
        let memberLocationData = Firestore.firestore().collection("group/\(groupID)/member")
        
        memberLocationData.addSnapshotListener { (querySnapshot, _) in
            
            guard let querySnapshot = querySnapshot else { return }
            
            querySnapshot.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added {
                    
                    guard
                        let memberName = documentChange.document.data()["name"] as? String,
                        let memberLocation = documentChange.document.data()["location"] as? GeoPoint
                    else { return }
                    
                    let locationOfMember = LocationOfMember(name: memberName,
                                                            location: memberLocation.transferToCoordinate2D())
                    
                    ridingViewController.locationOfMember.append(locationOfMember)
                    
                }
                
                if documentChange.type == .modified {
                    
                    guard
                        let memberName = documentChange.document.data()["name"] as? String,
                        let memberLocation = documentChange.document.data()["location"] as? GeoPoint
                    else { return }
                    
                    for number in 0..<ridingViewController.locationOfMember.count {
                    
                        if memberName == ridingViewController.locationOfMember[number].name {
                            
                            ridingViewController.locationOfMember.remove(at: number)
                            
                            let locationOfMember = LocationOfMember(name: memberName,
                                                                    location: memberLocation.transferToCoordinate2D())
                            
                            ridingViewController.locationOfMember.append(locationOfMember)
                            
                        } else {
                            
                            continue
                        }
                    }
                }
            })
        }
    }
    
    // 監聽結果
    func observerOfResult(_ ridingResultVC: RidingResultViewController, _ groupID: String) {
        
        let ridingResultData = Firestore.firestore().collection("group/\(groupID)/member")
        
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
        
        let ridingResultData =
            Firestore.firestore().collection("group").document(groupID)
            .collection("member").order(by: "spendTime", descending: false)
        
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
        
        let userInfo = Firestore.firestore().collection("group/\(groupID)/member").document(userUID)
        
        userInfo.setData(ridingData)
    }
}
