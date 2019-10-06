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
    
    let imagePickerViewController = ImagePickerViewController()

    let titleOfCell = ["隱私權政策", "登出"]
    
    @IBOutlet weak var uiView: UIView! {
        didSet {
            
            uiView.backgroundColor = UIColor.hexStringToUIColor()
        }
    }
    
    @IBOutlet weak var userImage: UIImageView! {
        didSet {
            
            userImage.addRound(radius: Double(userImage.bounds.width / 2),
                               backgroundColor: .white)
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var uploadPhotoButton: UIButton! {
        didSet {
            
            uploadPhotoButton.addRound(radius: Double(uploadPhotoButton.bounds.height / 2),
                                       backgroundColor: .white)
        }
    }
    
    @IBOutlet weak var profileTableView: UITableView! {
        
        didSet {
            
            profileTableView.dataSource = self
            
            profileTableView.delegate = self
            
            profileTableView.registerCell(nibName: ProfileCell.identifier)
            
            profileTableView.contentInset.top = 10
        }
    }
    
    @IBAction func uploadPhotoAction() {
        
        imagePickerViewController.delegate = self
        
        let imagePickerAlertController = imagePickerViewController.createAlertController(self)
        
        present(imagePickerAlertController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true

        if let userName = FirebaseAccountManager.shared.userName {
            
            userNameLabel.text = userName
        }
        
        if let photoURL = FirebaseAccountManager.shared.userPhotoURL {
            
            userImage.setImage(urlString: photoURL)
        }
        
        userImage.image = UIImage.setIcon(.UChu)
    }
}

extension UserProfileController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleOfCell.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier,
                                                 for: indexPath)
        
        guard let profileCell = cell as? ProfileCell else { return cell }
        
        profileCell.titleLabel.text = titleOfCell[indexPath.row]
        
        profileCell.nextPageImage.alpha = 0
        
        switch indexPath.row {
        
        case 0: return profileCell
            
            // profileCell.accessoryType = .disclosureIndicator

        case 1:
            
            profileCell.titleLabel.textColor = .hexStringToUIColor()
            
            return profileCell

        default: return profileCell
        }
    }
}

extension UserProfileController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            
            toPrivacyWebView()
            
        case 1:
            
            onClickLogout()
                        
        default:
            return
        }
    }
    
    func toPrivacyWebView() {
                
        let webViewVC = StoryboardCategory.privacyWeb.get
            .instantiateViewController(identifier: PrivacyWebController.identifier)
        
        present(webViewVC, animated: true, completion: nil)
    }
    
    func onClickLogout() {
        
        UserDefaults.standard.removeObject(forKey: "UserUID")
        
        do {
            
            try Auth.auth().signOut()
            
            self.showAlert("登出成功") { (_) in

                self.tabBarController?.selectedIndex = 1
            }
            // User 資料記得清空啊
            FirebaseAccountManager.shared.userName = nil
            
            FirebaseAccountManager.shared.userPhotoURL = nil
            
            if FirebaseDataManager.groupObserverFor != nil {
                
                FirebaseDataManager.groupObserverFor.remove()
            }
            
        } catch let error as NSError {
            
            self.showAlert(error.localizedDescription)
        }
    }
}

extension UserProfileController: ImagePickerViewControllerDelegate {
   
    func uploadImage(image: UIImage?) {
       
        if let selectedImage = image {
            
            guard
                let userUID = FirebaseAccountManager.shared.userUID
            else { return }
                        
            FirebaseStorageManager.uploadUserImage(selectedImage: selectedImage,
                                                   userUID: userUID) { [weak self] (url) in
                
                self?.userImage.alpha = 0
        
                self?.userImage.kf.setImage(with: url)

                UIView.animate(withDuration: 1) {
                    
                    self?.userImage.alpha = 1
                }
            }
        }
        
        dismiss(animated: true)
    }
}
