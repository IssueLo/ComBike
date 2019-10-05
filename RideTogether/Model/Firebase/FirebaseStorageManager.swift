//
//  FirebaseStorageManager.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import FirebaseStorage

class FirebaseStorageManager {
    
    static var storage = Storage.storage().reference()
    
    static func uploadGroupImage(selectedImage: UIImage, groupUID: String) {
        
        let storageRef = storage.child("GroupPhoto").child("\(groupUID).png")
        
        if let uploadData = selectedImage.pngData() {

            storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                
                if error != nil {

                    print("Error: \(error!.localizedDescription)")
                    
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    
                    if let error = error {
                        
                        print(error)
                        
                    } else {
                        
                        print(url as Any)
                        
                        guard let url = url else { return }
                        
                        FirebaseDataManager.shared.updateGroupPhoto(groupUID,
                                                                    url.absoluteString)
                    }
                }
            })
        }
    }
    
    static func uploadUserImage(selectedImage: UIImage, userUID: String, handler: @escaping (URL) -> Void) {
        
        let storageRef = storage.child("UserPhoto").child("\(userUID).png")

        if let uploadData = selectedImage.pngData() {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                
                if error != nil {
                    
                    print("Error: \(error!.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    
                    if let error = error {
                        
                        print(error)
                    } else {
                        
                        print(url as Any)
                        
                        guard let url = url else { return }
                        
                        handler(url)
//                        self?.userImage.kf.setImage(with: url)
                        
                        FirebaseAccountManager.shared.userPhotoURL = url.absoluteString

                        FirebaseDataManager.shared.updateUserPhoto(userUID,
                                                                   url.absoluteString)
                    }
                }
            })
        }
    }
}
