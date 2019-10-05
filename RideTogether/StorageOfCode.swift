//
//  StorageOFCode.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/16.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

/*
 
guard let documents = querySnapshot?.documents else {
    
    return
}

var groupDataArray = [GroupData]()

for document in documents {
    
    guard
        let name = document.data()["name"] as? String,
        let member = document.data()["member"] as? [String],
        let isFinished = document.data()["isFinished"] as? Bool,
        let createTime = document.data()["createTime"] as? Timestamp
        else { continue }
    
    print(createTime.dateValue())
    
    let groupID = document.documentID
    
    let groupData = GroupData(groupID: groupID,
                              name: name,
                              member: member,
                              isFinished: isFinished,
                              createTime: createTime)
    
    groupDataArray.append(groupData)
    
    continue
}

completion(Result.success(groupDataArray))
 
 */

/*
 
 GroupListViewController
 
FirebaseDataManager.shared.observerForGroupData(uesrUID) { [weak self] (result) in
    
    switch result {
        
    case .success(let groupData): self?.groupData = groupData
        
    case .failure: self?.showAlert("GroupDetailVC - 101")
    }
}
*/

/*

// 搜尋會員所屬群組 - 待刪除
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

// 監聽新增成員 - 待刪除
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

// 抓取群組資料 - 待刪除
private func getDataFromGroup(_ groupVC: GroupListViewController,
                              _ groupID: String,
                              _ name: String,
                              _ member: [String]) {
    
    let dataInfo = Firestore.firestore().collection("group/\(groupID)/member")
    
    dataInfo.getDocuments { (querySnapshot, _) in
        
        if let querySnapshot = querySnapshot {
            
            var memberInfoArray = [MemberData]()
            
            for document in querySnapshot.documents {
                
                guard
                    let name = document.data()["name"] as? String
                    
                    else { return }
                
                var memberInfo = MemberData(memberName: name)
                
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
            
            儲存群組資料
            groupVC.groupInfoArray.insert(group, at: 0)
        }
    }
}
 
*/

/*
// 將群組狀態改為已完成
private func groupIsFinished(groupID: String) {
    
    let groupDocument = groupDatebase.document(groupID)
    
    database.runTransaction({ (transaction, errorPointer) -> Any? in
        
        var myDocument: DocumentSnapshot
        
        do {
            
            try myDocument = transaction.getDocument(groupDocument)
            
        } catch let fetchError as NSError {
            
            return nil
        }
        
        transaction.updateData([GroupKey.isFinished.rawValue: true], forDocument: groupDocument)
        
        return nil
        
    }) { (object, error) in
        
        if let error = error {
            
            print("Transaction failed: \(error)")
            
        } else {
            
            print("Transaction successfully committed!")
        }
    }
}
*/
