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
            
            memberListTableView.dataSource = self
            
            memberListTableView.registerCell(nibName: ListCell.identifier)
            
            memberListTableView.contentInset.bottom = 12
            
            memberListTableView.contentInset.top = 12
        }
    }
    
    @IBOutlet weak var startBtn: UIButton! {
        
        didSet {

            startBtn.addRound(backgroundColor: .hexStringToUIColor())
            
            startBtn.setTitleColor(.white, for: .normal)
                        
            startBtn.addTarget(self,
                               action: #selector(startRiding),
                               for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
                
        navigationItem.title = groupData.name
                        
        createObserverOfMember(groupID: groupData.groupID)

        setNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        FirebaseDataManager.memberObserverFor.remove()
    }
    
    func createObserverOfMember(groupID: String) {
        
        FirebaseDataManager.shared.observerForMemberData(groupID) { [weak self](result) in
            
            switch result {
                
            case .success(let memberData):
                
                self?.memberData = memberData
                
            case .failure:
                
                return
            }
        }
    }
    
    func setNavigationButton() {
        
        let qrCodeBtn = UIBarButtonItem(image: UIImage.setIcon(.Icons_QRCode),
                                        style: .plain,
                                        target: self,
                                        action: #selector(showQRCodeVC))
        
        let addGroupPhotoBtn = UIBarButtonItem(image: UIImage.setIcon(.Icons_Camera),
                                               style: .plain,
                                               target: self,
                                               action: #selector(uploadPhotoAction))
        
        navigationItem.rightBarButtonItems = [qrCodeBtn, addGroupPhotoBtn]
    }
    
    @objc func showQRCodeVC() {
        
        guard let qrCodeVC = StoryboardCategory.qrCode.get.instantiateViewController(
            withIdentifier: QRCodeViewController.identifier
            ) as? QRCodeViewController
            
        else { return }
        
        qrCodeVC.groupID = groupData.groupID
        
        qrCodeVC.modalPresentationStyle = .overFullScreen
        
        present(qrCodeVC, animated: false)
    }
    
    let imagePickerController = ImagePickerViewController()
    
    @objc
    func uploadPhotoAction() {

        imagePickerController.delegate = self

        let imagePickerAlertController = imagePickerController.createAlertController(self)

        present(imagePickerAlertController, animated: true)
    }
    
    @objc
    func startRiding() {

        guard
            let ridingVC = StoryboardCategory.riding.get.instantiateViewController(
                withIdentifier: RidingViewController.identifier
                ) as? RidingViewController
            
        else { return }

        ridingVC.groupData = groupData
        
        ridingVC.modalPresentationStyle = .fullScreen
        // 指定轉場
        ridingVC.transitioningDelegate = self

        present(ridingVC, animated: true, completion: nil)
    }
}

extension GroupDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath)
        
        guard
            let groupListCell = cell as? ListCell
            
        else { return cell }
        
        groupListCell.groupNameLabel.text = self.memberData[indexPath.row].name
        
        groupListCell.statusLabel.alpha = 0
        
        if let photoURLString = self.memberData[indexPath.row].photoURLString {
            
            groupListCell.groupImage.setImage(urlString: photoURLString)
            
        } else {
            
            groupListCell.groupImage.image = UIImage.setIcon(.UChu)
        }
        
        return groupListCell
    }
}

extension GroupDetailViewController: ImagePickerViewControllerDelegate {
    
    func uploadImage(image: UIImage?) {
        
        if let selectedImage = image {
            
            let groupUID = self.groupData.groupID
            
            FirebaseStorageManager.uploadGroupImage(selectedImage: selectedImage, groupUID: groupUID)
        }
        
        dismiss(animated: true)
    }
}

// 轉場效果
extension GroupDetailViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition = StartFadeOutTransition()
        
        transition.handler = {
                              
            self.navigationController?.navigationBar.isHidden = true
            
            self.startBtn.translatesAutoresizingMaskIntoConstraints = true
            
            self.startBtn.frame = CGRect(x: -30,
                                         y: -30,
                                         width: UIScreen.main.bounds.width + 60,
                                         height: UIScreen.main.bounds.height + 60)
        }
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        let transition = StartFadeOutTransition()
        
        transition.handler = {
                                        
            self.startBtn.translatesAutoresizingMaskIntoConstraints = false
        }
        
        return transition
    }
}
