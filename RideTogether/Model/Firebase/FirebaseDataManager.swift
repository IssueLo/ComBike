//
//  FirebaseTest.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/8/30.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MapKit

typealias GroupDataHandler = (Result<GroupData>) -> Void

typealias MemberDataHandler = (Result<MemberData>) -> Void

// swiftlint:disable multiple_closures_with_trailing_closure
// swiftlint:disable type_body_length
// swiftlint:disable file_length
class FirebaseDataManager {
    
    static let shared = FirebaseDataManager()
    
    private init() {}
    
    static var memberObserverFor: ListenerRegistration!
    
    static var groupObserverFor: ListenerRegistration!
        
    let database = Firestore.firestore()
    
    let userInfoDatabase = Firestore.firestore().collection(FirebaseKey.userInfo.rawValue)
    
    let groupDatabase = Firestore.firestore().collection(FirebaseKey.group.rawValue)
    
    // MARK: deleteAllGroup
    func deleteGroup(_ groupID: String) {
        
        let groupOfUser = groupDatabase.document(groupID)

        groupOfUser.delete()
    }
    
    // MARK: Group 監聽
    // 監聽跟排序無法同時設置
    func observerForGroupData(_ userID: String, completion: @escaping (Result<GroupData>) -> Void) {
        
        let groupOfUser = groupDatabase.whereField(GroupKey.member.rawValue, arrayContains: userID)
//            .order(by: GroupKey.createTime.rawValue, descending: true)
        
        FirebaseDataManager.groupObserverFor = groupOfUser.addSnapshotListener { (querySnapshot, error) in
            
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
                    
                    let groupPhotoURL = documentChange.document.data()["photoURLString"] as? String

                    let groupData = GroupData(groupID: groupID,
                                              photoURLString: groupPhotoURL,
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
                    
                    let groupPhotoURL = documentChange.document.data()["photoURLString"] as? String
                    
                    let groupData = GroupData(groupID: groupID,
                                              photoURLString: groupPhotoURL,
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
    
    // MARK: 可能可以排序？
    private func groupData(_ userID: String, completion: @escaping (Result<GroupData>) -> Void) {
        
    }
    
    // MARK: Member 監聽
    func observerForMemberData(_ groupID: String, completion: @escaping (Result<[MemberData]>) -> Void) {
        
        let memberOfGroup = groupDatabase.document(groupID).collection(GroupKey.member.rawValue)
        
        FirebaseDataManager.memberObserverFor = memberOfGroup.addSnapshotListener { (querySnapshot, _) in
            
            guard let documents = querySnapshot?.documents else {
                
                return
            }
            
            var memberData = [MemberData]()
            
            for document in documents {
                
                guard let name = document.data()["name"] as? String
                    else { return }
                
                var member = MemberData(memberName: name, memberNameUID: document.documentID)
                
                self.searchMemberPhoto(memberUID: document.documentID, completion: { (result) in
                    
                    switch result {
                        
                    case .success(let memberUID):
                        
                        member.photoURLString = memberUID
                        
                        memberData.append(member)
                        
                        completion(Result.success(memberData))
                        
                    case .failure:
                        
                        return
                    }
                })
            }
            
//            querySnapshot.documentChanges.forEach({ (documentChange) in
//
//                if documentChange.type == .added {
//
//                    guard let name = documentChange.document.data()["name"] as? String
//                        else { return }
//
//                    let memberData = MemberData(memberName: name)
//
//                    return completion(Result.success(memberData))
//                }
//
//                // 退出群組
//                if documentChange.type == .removed {
//
//                    guard let name = documentChange.document.data()["name"] as? String
//                        else { return }
//
//                    let memberData = MemberData(memberName: name)
//
//                    return completion(Result.success(memberData))
//                }
//            })
//
//            guard error == nil else {
//
//                return completion(Result.failure(error!))
//            }
        }
    }
    
    // MARK: 用 uid 搜尋 Photo
    func searchMemberPhoto(memberUID: String, completion: @escaping (Result<String?>) -> Void) {
        
        let userInfoDocument = userInfoDatabase.document(memberUID)
        
        userInfoDocument.getDocument { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                let memberPhotoURL = querySnapshot.data()?[UserInfoKey.photoURL.rawValue] as? String
                
                completion(Result.success(memberPhotoURL))
            }
        }
    }

    // MARK: 新加入會員資料 - Done
    func addUserInfo(_ userUID: String,
                     _ userName: String,
                     _ userEmail: String) {
        
        let userInfoData: [String: Any] = [UserInfoKey.name.rawValue: userName,
                                           UserInfoKey.email.rawValue: userEmail]
        
        userInfoDatabase.document(userUID).setData(userInfoData)
    }
    
    // MARK: 更新 User 照片 - Done
    func updateUserPhoto(_ userUID: String,
                         _ userPhotoURL: String) {
        
        let userPhotoData: [String: Any] = [UserInfoKey.photoURL.rawValue: userPhotoURL]
        
        userInfoDatabase.document(userUID).setData(userPhotoData, merge: true)
    }
    
    // MARK: 更新 Group 照片 - Done
    func updateGroupPhoto(_ groupUID: String,
                          _ groupPhotoURL: String) {
        
        let groupPhotoData: [String: Any] = [GroupKey.photoURLString.rawValue: groupPhotoURL]
        
        groupDatabase.document(groupUID).setData(groupPhotoData, merge: true)
    }
    
    // MARK: 建立群組 - Done
    func createGroup(_ groupName: String, completion: @escaping (String) -> Void) {
        
        // 要打兩次 API，所以要知道 groupID
        let groupID = groupDatabase.document().documentID
        
        guard
            let userUID = FirebaseAccountManager.shared.userUID,
            let userName = FirebaseAccountManager.shared.userName
        else { return }
        
        let createTime = Timestamp()
        
        print("createTime: \(createTime)")
        
        groupDatabase.document(groupID).setData([GroupKey.name.rawValue: groupName,
                                                 GroupKey.member.rawValue: [userUID],
                                                 GroupKey.isFinished.rawValue: false,
                                                 GroupKey.createTime.rawValue: createTime])
        
        groupDatabase.document("\(groupID)/\(GroupKey.member.rawValue)/\(userUID)")
            .setData([GroupKey.name.rawValue: userName])
        
        completion("成功創建群組")
    }
    
    // MARK: 編輯群組 - 增加成員
    func addUserIntoGroup(groupID: String,
                          userUID: String,
                          userName: String,
                          completion: @escaping (String) -> Void) {
        
        let groupDocument = groupDatabase.document(groupID)
        
//        groupDocument.getDocument { (querySnapshot, _) in
//
//            if let querySnapshot = querySnapshot {
//
//                guard
//                    let groupName = querySnapshot.data()?[GroupKey.name.rawValue] as? String,
//                    var member = querySnapshot.data()?[GroupKey.member.rawValue] as? [String]
//                else { return }
//
//                for currentMember in member {
//
//                    while userUID == currentMember {
//
//                        print("已經加入了喔")
//
//                        return
//                    }
//                }
//
//                member.append(userUID)
//
//                groupDocument.setData([GroupKey.name.rawValue: groupName,
//                                       GroupKey.member.rawValue: member])
//
//                groupDocument.collection(GroupKey.member.rawValue).document(userUID)
//         .setData([GroupKey.name.rawValue: userName])
//            }
//        }
 
        database.runTransaction({ (transaction, _) -> Any? in
            
            let myDocument: DocumentSnapshot
            
            do {
                
                try myDocument = transaction.getDocument(groupDocument)
                
            } catch {
                
                return nil
            }
            
            guard var memberInGroup = myDocument.data()?[GroupKey.member.rawValue] as? [String] else {
                
                completion("找不到此群組喔")
                
                return nil
            }
            
            for member in memberInGroup {
                
                if member == userUID {
                    
                    completion("已經在群組內了喔")
                    
                    return nil
                    
                } else {
                    
                    continue
                }
            }
            
            memberInGroup.append(userUID)
            
            transaction.updateData([GroupKey.member.rawValue: memberInGroup], forDocument: groupDocument)
            
            groupDocument.collection(GroupKey.member.rawValue).document(userUID)
                .setData([GroupKey.name.rawValue: userName])
            
            completion("已成功加入群組")
            
            return nil
            
        }) { (_, error) in
            
            if let error = error {
                
                print("Transaction failed: \(error)")
                
            } else {
                
                print("Transaction successfully committed!")
            }
        }
    }
    
    // MARK: 退出群組
    func removeUserFromGroup(groupID: String,
                             userUID: String) {
        
        let groupDocument = groupDatabase.document(groupID)
        
        let memberDocument = groupDocument.collection(GroupKey.member.rawValue).document(userUID)
        
        memberDocument.delete()
        
        database.runTransaction({ (transaction, _) -> Any? in
            
            let myDocument: DocumentSnapshot
            
            do {
                
                try myDocument = transaction.getDocument(groupDocument)
                
            } catch {
                
                return nil
            }
            
            guard var memberInGroup = myDocument.data()?[GroupKey.member.rawValue] as? [String] else {
                
                return nil
            }
            
            for number in 0..<memberInGroup.count {
                
                if userUID == memberInGroup[number] {
                    
                    memberInGroup.remove(at: number)
                    
                    break
                    
                } else {
                    
                    continue
                }
            }
            
            transaction.updateData([GroupKey.member.rawValue: memberInGroup], forDocument: groupDocument)
            
            return nil
            
        }) { (_, error) in
            
            if let error = error {
                
                print("Transaction failed: \(error)")
                
            } else {
                
                print("Transaction successfully committed!")
            }
        }
    }
    
    // MARK: 編輯群組 - 更改群組名稱(要修改)
    func modifyGroupName(_ groupID: String, _ groupName: String) {
        
        let groupDocument = groupDatabase.document(groupID)
        
        groupDocument.getDocument { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                guard
                    let member = querySnapshot.data()?["member"] as? [String]
                else { return }
                
                groupDocument.setData(["name": groupName, "member": member])
            }
        }
    }
    
    // MARK: 用 uid 搜尋會員 Name - Done
    func getUserInfo(_ userID: String) {
        
        let userInfoDocument = userInfoDatabase.document(userID)
        
        userInfoDocument.getDocument { (querySnapshot, _) in
                        
            if let querySnapshot = querySnapshot {
                
                FirebaseAccountManager.shared.userName = querySnapshot.data()?[UserInfoKey.name.rawValue] as? String
                
                FirebaseAccountManager.shared.userEmail = querySnapshot.data()?[UserInfoKey.email.rawValue] as? String
                
                FirebaseAccountManager.shared.userPhotoURL = querySnapshot.data()?[UserInfoKey.photoURL.rawValue]
                    as? String
            }
        }
    }
    
    // MARK: 上傳使用者所在位置 - Done
    func uploadUserLocation(_ groupID: String, _ userUID: String, _ userLocation: CLLocationCoordinate2D) {
        
        let userInfo = groupDatabase.document(groupID).collection(GroupKey.member.rawValue).document(userUID)
        
        let geoPoint = userLocation.transferToGeopoint()
        
        let locationData = ["name": FirebaseAccountManager.shared.userName!,
                            "location": geoPoint] as [String: Any]
        
        userInfo.setData(locationData)
    }
    
    // MARK: 監聽同伴所在位置 - Done
    func observerOfMemberLocation(_ groupID: String, completion: @escaping (LocationOfMember) -> Void) {
        
        let memberLocationData = groupDatabase.document(groupID).collection(GroupKey.member.rawValue)
        
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
                    
                    completion(locationOfMember)
                }
                
                if documentChange.type == .modified {
                    
                    guard
                        let memberName = documentChange.document.data()["name"] as? String,
                        let memberLocation = documentChange.document.data()["location"] as? GeoPoint
                    else { return }
                    
                    let locationOfMember = LocationOfMember(name: memberName,
                                                            location: memberLocation.transferToCoordinate2D())
                    
                    completion(locationOfMember)
                }
            })
        }
    }
    
    // MARK: 監聽結果 - Done
    func observerOfResult(_ groupID: String, completion: @escaping ([MemberData]) -> Void) {
        
        let ridingResultData = groupDatabase.document(groupID).collection(GroupKey.member.rawValue)
        
        ridingResultData.addSnapshotListener { (querySnapshot, _) in
            
            guard let querySnapshot = querySnapshot else { return }
            
            querySnapshot.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added {
                    
                    self.updateRidingResult(groupID, completion: completion)
                }
                
                if documentChange.type == .modified {
                    
                    self.updateRidingResult(groupID, completion: completion)
                }
            })
        }
    }
    
    // MARK: 更新結果 - Done
    private func updateRidingResult(_ groupID: String, completion: @escaping ([MemberData]) -> Void) {
        
        let ridingResultData = groupDatabase.document(groupID).collection(GroupKey.member.rawValue)
            .order(by: "spendTime", descending: false)
        
        ridingResultData.getDocuments { (querySnapshot, _) in
            
            if let querySnapshot = querySnapshot {
                
                var ridingResultArray = [MemberData]()
                
//                let group = DispatchGroup()
                
                for document in querySnapshot.documents {
                    
//                    group.enter()
                    
                    guard
                        let memberName = document.data() ["name"] as? String,
                        let spendTime = document.data() ["spendTime"] as? Int,
                        let distance = document.data() ["distance"] as? Double,
                        let averageSpeed = document.data() ["averageSpeed"] as? Double,
                        let maximumSpeed = document.data() ["maximumSpeed"] as? Double,
                        let altitude = document.data() ["altitude"] as? [Double],
                        let route = document.data() ["route"] as? [GeoPoint]
                    else { return }
                    
                    var memberInfo = MemberData(memberName: memberName, memberNameUID: document.documentID)
                    
                    memberInfo.spendTime = spendTime
                    print("SpendTime:\(spendTime)")
                    memberInfo.distance = distance
                    
                    memberInfo.averageSpeed = averageSpeed
                    
                    memberInfo.maximumSpeed = maximumSpeed
                    
                    memberInfo.altitude = altitude
                    
                    memberInfo.route = route
                    
                    ridingResultArray.append(memberInfo)
                    
//                    group.leave()
                    // 照片 API 回來的時間不是照發出 request 時間排序的
//                    self.searchMemberPhoto(memberUID: document.documentID, completion: { (result) in
//
//                        switch result {
//
//                        case .success(let memberUID):
//
//                            memberInfo.photoURLString = memberUID
//
//                            ridingResultArray.append(memberInfo)
//
//                            group.leave()
//
//                        case .failure:
//
//                            return
//                        }
//                    })
                }
                
//                group.notify(queue: .main, execute: {
                    
                    completion(ridingResultArray)
                    
//                    print(ridingResultArray)
//                })
            }
        }
    }
    
    // MARK: 上傳騎乘紀錄 要把 isFinish 改為 true
    func uploadRidingData(_ groupID: String, _ userUID: String, _ ridingData: MemberData) {
        
        let userInfo = groupDatabase.document(groupID).collection(GroupKey.member.rawValue).document(userUID)
        
        let ridingData = [MemberInfoKey.name.rawValue: ridingData.name,
                          MemberInfoKey.spendTime.rawValue: ridingData.spendTime!,
                          MemberInfoKey.distance.rawValue: ridingData.distance!,
                          MemberInfoKey.averageSpeed.rawValue: ridingData.averageSpeed!,
                          MemberInfoKey.maximumSpeed.rawValue: ridingData.maximumSpeed!,
                          MemberInfoKey.route.rawValue: ridingData.route!,
                          MemberInfoKey.altitude.rawValue: ridingData.altitude! ] as [String: Any]
        
        userInfo.setData(ridingData)
        
        self.groupIsFinished(groupID: groupID)
    }
    
    // MARK: 將群組狀態改為已完成
    private func groupIsFinished(groupID: String) {
        
        let groupDocument = groupDatabase.document(groupID)
        
        groupDocument.setData(["isFinished": true], merge: true)
    }
    
    // MARK: 新加入 Apple SignIn會員資料 - Done
    func appleSignIn(_ userUID: String,
                     _ userName: String,
                     _ userEmail: String) {
        
        let userInfoData: [String: Any] = [UserInfoKey.name.rawValue: userName,
                                           UserInfoKey.email.rawValue: userEmail]
        
        userInfoDatabase.document(userUID).setData(userInfoData, merge: true)
    }
}
// swiftlint:enable multiple_closures_with_trailing_closure
// swiftlint:enable type_body_length
// swiftlint:enable file_length
