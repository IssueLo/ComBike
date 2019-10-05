//
//  FirebaseStorageManager.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import FirebaseStorage

class FirebaseStorageManager {
    
    static func uploadImage(selectedImage: UIImage, groupUID: String) {
        
        let storageRef = Storage.storage().reference().child("GroupPhoto").child("\(groupUID).png")
        
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
}
