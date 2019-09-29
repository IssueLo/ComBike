//
//  GroupDetailViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import FirebaseStorage

class GroupDetailViewController: UIViewController {
    
    var groupData: GroupData!
    
    var memberData = [MemberData]() {
        
        didSet {
            
            memberListTableView.reloadData()
        }
    }
    
    @IBOutlet weak var memberListTableView: UITableView! {
        
        didSet {
            
            memberListTableView.contentInset.bottom = 12
            
            memberListTableView.contentInset.top = 12
        }
    }
    
    @IBOutlet weak var startBtn: UIButton! {
        
        didSet {

            startBtn.addRound(backgroundColor: .hexStringToUIColor())
            
            startBtn.setTitleColor(.white, for: .normal)
            
            startBtn.addShadow()
            
            startBtn.addTarget(self, action: #selector(startRiding), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = groupData.name
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)
        
        memberListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        
        creatObserverOfMember(groupID: groupData.groupID)

        setNavigationButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FirebaseDataManeger.memberObserverFor.remove()
    }
    
    func creatObserverOfMember(groupID: String) {
        
        FirebaseDataManeger.shared.observerForMemberData(groupID) { [weak self](result) in
            
            switch result {
                
            case .success(let memberData):
                
                self?.memberData = memberData
                
            case .failure:
                
                self?.showAlert("GroupDetailVC - 101")
            }
        }
    }
    
    func setNavigationButton() {
        
        let qrCodeBtn = UIBarButtonItem(image: UIImage(named: "Icons_QRCode"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(showQRCodeVC))
        
        let addGroupPhotoBtn = UIBarButtonItem(image: UIImage(named: "Icons_Camera"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(uploadPhotoAction))
        
        navigationItem.rightBarButtonItems = [qrCodeBtn, addGroupPhotoBtn]
        
    }
    
    @objc func showQRCodeVC() {
        
        let storyboard = UIStoryboard.init(name: "QRCodeStoryboard", bundle: nil)
        
        guard let qrCodeVC = storyboard.instantiateViewController(withIdentifier: "QRCodeViewController")
            as? QRCodeViewController
        else { return }
        
        qrCodeVC.groupID = groupData.groupID
        
        qrCodeVC.modalPresentationStyle = .overFullScreen
        
        present(qrCodeVC, animated: false, completion: nil)
    }
    
    @objc func uploadPhotoAction() {
        
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
    
    @objc func startRiding() {
            
        let storyboard = UIStoryboard.init(name: "RidingStoryboard", bundle: nil)
        
        guard
            let ridingVC = storyboard.instantiateViewController(withIdentifier: "RidingViewController")
            as? RidingViewController
        else { return }

        ridingVC.groupData = groupData
        
        ridingVC.modalPresentationStyle = .fullScreen
    
        present(ridingVC, animated: true, completion: nil)
//        show(ridingVC, sender: nil)
    }
}

extension GroupDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell", for: indexPath)
        
        guard let groupListCell = cell as? GroupListCell else { return cell }
        
        groupListCell.groupNameLabel.text = self.memberData[indexPath.row].name
        
        groupListCell.statusLabel.alpha = 0
        
        guard let photoURLString = self.memberData[indexPath.row].photoURLString else {
            
            groupListCell.groupImage.image = UIImage(named: "UChu")
            
            return groupListCell
        }
        
        groupListCell.groupImage.setImage(urlString: photoURLString)
        
        return groupListCell
    }
}

extension GroupDetailViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 70
//    }
}

extension GroupDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        // 取得從 UIImagePickerController 選擇的檔案
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage.resizeImage(targetSize: CGSize(width: 500, height: 300))
        }
        
        // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
        if let selectedImage = selectedImageFromPicker {
            
            let storageRef = Storage.storage().reference().child("GroupPhoto").child("\(groupData.groupID).png")
            
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
                            
                            guard
                                let url = url,
                                let groupUID = self?.groupData.groupID
                            else { return }
                            
//                            self?.userImage.kf.setImage(with: url)

                            FirebaseDataManeger.shared.updateGroupPhoto(groupUID,
                                                                        url.absoluteString)
                        }
                    }
                })
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}
