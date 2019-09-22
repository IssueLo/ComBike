//
//  UserProfileController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/11.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class UserProfileController: UIViewController {
    
    var titleOfCellSection1 = ["使用者條款", "隱私權政策"]
    
    var titleOfCellSection2 = ["給我們好評👍", "登出"]
    
    @IBOutlet weak var uiView: UIView! {
        didSet {
            
            uiView.backgroundColor = UIColor.hexStringToUIColor()
//            let grandientLayer = CAGradientLayer()
//
//            grandientLayer.frame = uiView.bounds
//
//            grandientLayer.colors = [UIColor.white.cgColor //UIColor.red.cgColor
//                                     ,UIColor(red: 255, green: 126, blue: 121, alpha: 0).cgColor
//            ]
//
//            grandientLayer.startPoint = CGPoint(x: 0, y: 0)
//
//            grandientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//
//            uiView.layer.insertSublayer(grandientLayer, at: 0)
        }
    }
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            
            userImage.layer.cornerRadius = 64
            
            userImage.layer.borderWidth = 3
            
            userImage.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var uploadPhotoButton: UIButton! {
        didSet {
            
            uploadPhotoButton.addRound(radis: 21)
            
            uploadPhotoButton.layer.borderWidth = 2
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
    
    func onClickLogout() {
        
        do {
            
            try Auth.auth().signOut()
            
            self.showAlert("登出成功") { (_) in
                
                self.tabBarController?.selectedIndex = 0
            }
            
            // User 資料記得清空啊
            FirebaseAccountManager.shared.userName = nil
            
            FirebaseAccountManager.shared.userPhotoURL = nil
            
            if FirebaseDataManeger.groupObserverFor != nil {
                
                FirebaseDataManeger.groupObserverFor.remove()
            }
            
        } catch let error as NSError {
            
            self.showAlert(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProfileCell", bundle: nil)
        
        profileTableView.register(nib, forCellReuseIdentifier: "ProfileCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let userName = FirebaseAccountManager.shared.userName else {
            
            return
        }
        
        navigationController?.navigationBar.topItem?.title = userName + "の個人頁面"
        
        guard let photoURL = FirebaseAccountManager.shared.userPhotoURL else {
            
            userImage.image = UIImage(named: "UChu")
            
            return
        }
        
        userImage.setImage(urlString: photoURL)
    }
}

extension UserProfileController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0: return 2
        
        case 1: return 2
        
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        guard let profileCell = cell as? ProfileCell else { return cell }
        
        switch indexPath.section {
        
        case 0:
            
            profileCell.titleLabel.text = titleOfCellSection1[indexPath.row]
            
            profileCell.accessoryType = .disclosureIndicator

        case 1: profileCell.titleLabel.text = titleOfCellSection2[indexPath.row]

        default: return profileCell
        }
        
        return profileCell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
            self.onClickLogout()
            
            self.backToRoot()
        }
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
            
            selectedImageFromPicker = pickedImage.resizeImage(targetSize: CGSize(width: 500, height: 300))
        }
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            guard
                let userUID = FirebaseAccountManager.shared.userUID
            else { return }
            
            let storageRef = Storage.storage().reference().child("UserPhoto").child("\(userUID).png")
            
            if let uploadData = selectedImage.pngData() {
                
                // 這行就是 FirebaseStorage 關鍵的存取方法。
                storageRef.putData(uploadData, metadata: nil, completion: { (_, error) in
                    
                    if error != nil {
                        
                        // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    storageRef.downloadURL { [weak self](url, error) in
                        
                        if let error = error {
                            
                            print(error)
                        } else {
                            
                            print(url as Any)
                            
                            guard let url = url else { return }
                            
                            self?.userImage.kf.setImage(with: url)
                            
                            FirebaseAccountManager.shared.userPhotoURL = url.absoluteString

                            FirebaseDataManeger.shared.updateUserPhoto(userUID,
                                                                       url.absoluteString)
                        }
                    }
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
