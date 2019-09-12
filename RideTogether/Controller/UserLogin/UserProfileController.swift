//
//  UserProfileController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/11.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import Kingfisher

class UserProfileController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            
            userImage.layer.cornerRadius = 64
            
            userImage.layer.borderWidth = 3
            
            userImage.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBAction func uploadPhotoAction() {
        
        // 建立一個 UIImagePickerController 的實體
        let imagePickerController = UIImagePickerController()
        
        // 委任代理
        imagePickerController.delegate = self
        
        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let imagePickerAlertController = UIAlertController(title: "上傳圖片",
                                                           message: "請選擇要上傳的圖片",
                                                           preferredStyle: .actionSheet)
        
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (_) in
            
            // 判斷是否可以從照片圖庫取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (_) in
            
            // 判斷是否可以從相機取得照片來源
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.camera)，並 present UIImagePickerController
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (_) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(imagePickerAlertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProfileCell", bundle: nil)
        
        profileTableView.register(nib, forCellReuseIdentifier: "ProfileCell")
    }
    
    @IBOutlet weak var uiView: UIView! {
        didSet {
            let grandientLayer = CAGradientLayer()

            grandientLayer.frame = button.bounds
            
            grandientLayer.colors = [UIColor.white.cgColor, UIColor.red.cgColor]
            
            grandientLayer.startPoint = CGPoint(x: 0.25, y: 0)

            grandientLayer.endPoint = CGPoint(x: 0.75, y: 1)
            
            button.layer.addSublayer(grandientLayer)
        }
    }
}

extension UserProfileController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: return 2
        
        case 1: return 1
        
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
            
        guard let profileCell = cell as? ProfileCell else { return cell }
        
        return profileCell
    }
}

extension UserProfileController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
}

extension UserProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
//            userImage.image = pickedImage
            
            selectedImageFromPicker = pickedImage
        }
        
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
        let uniqueString = NSUUID().uuidString
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            print("uniqueString: \(uniqueString)")
            print("selectedImage: \(selectedImage)")
            
            let storageRef = Storage.storage().reference().child("PIC").child("\("123").png")
            
            if let uploadData = selectedImage.pngData() {
                // 這行就是 FirebaseStorage 關鍵的存取方法。
                storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                    
                    if error != nil {
                        
                        // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        
                        if let error = error {
                            
                            print(error)
                        } else {
                            
                            print(url as Any)
                            
                            self.userImage.kf.setImage(with: url)
                        }
                    }
                    
//                    storageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
//
//                        if let error = error {
//
//                            print("error: \(error)")
//                            print("data: \(data)")
//                        } else {
//
//                            print("data: \(data)")
//                            self.userImage.image = UIImage(data: data!)
//                        }
//                    })
                    // 連結取得方式就是：data?.downloadURL()?.absoluteString。
//                    if let uploadImageUrl = data.downloadURL()?.absoluteString {
//
//                        // 我們可以 print 出來看看這個連結事不是我們剛剛所上傳的照片。
//                        print("Photo Url: \(uploadImageUrl)")
//                    }
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
