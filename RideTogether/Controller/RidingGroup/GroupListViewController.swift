//
//  GroupViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController {
    
    var groupData = [GroupData]() {
        
        didSet {
            
            if groupData.count == 0 {
                
                remindBackView.alpha = 1
                
            } else {
                
                remindBackView.alpha = 0
            }
            
            DispatchQueue.main.async {
                
                self.groupListTableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var remindLabel: UILabel!
    
    @IBOutlet weak var remindBackView: UIView!
    
    @IBOutlet weak var createGroupBtn: UIButton! {
        
        didSet {
            
            createGroupBtn.addRound(backgroundColor: .hexStringToUIColor())
            
            createGroupBtn.setTitleColor(.white, for: .normal)
            
            createGroupBtn.addShadow()
            
            createGroupBtn.addTarget(self, action: #selector(createGroup), for: .touchUpInside)
        }
    }

    @IBOutlet weak var groupListTableView: UITableView! {
       
        didSet {
            
            // BottomSide 可往上多滑 100
            groupListTableView.contentInset.bottom = 12
            
            groupListTableView.contentInset.top = 12
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)

        groupListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        
        let creatGroupIcon = UIBarButtonItem(image: UIImage(named: "Icons_CreateGroup"),
                                             style: .done,
                                             target: self,
                                             action: #selector(createGroup))
        
        let scanIcon = UIBarButtonItem(image: UIImage(named: "Icons_QRCodeScan"),
                                       style: .done,
                                       target: self,
                                       action: #selector(scanQRCode))
        
        navigationItem.rightBarButtonItems = [scanIcon, creatGroupIcon]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uesrUID = FirebaseAccountManager.shared.userUID else {
            
            // 登出狀態清空 groupData 資料
            groupData = []
            
            return
        }
        
        // 登入且 groupData 資料為 0，建立監聽
        if groupData.count == 0 {
            
            creatObserverOfGroup(uesrUID: uesrUID)
        }
    }
    
    func creatObserverOfGroup(uesrUID: String) {
        
        FirebaseDataManeger.shared.observerForGroupData(uesrUID) { [weak self] (result) in

            switch result {
                
            case .success(let groupData):
                
                // 要判斷是新的群組，還是修改原有群組
                if self?.groupData.count != 0 {
                    
                    guard let groupDataCount = self?.groupData.count else { return }
                    
                    for number in 0..<groupDataCount {
                        
                        if groupData.groupID == self?.groupData[number].groupID {
                            
                            self?.groupData.remove(at: number)
                            
                            self?.groupData.insert(groupData, at: number)
                            
                            return
                        } else {
                            
                            continue
                        }
                    }
                }
                
                self?.groupData.insert(groupData, at: 0)
                
            case .failure:
                
                self?.showAlert("GroupDetailVC - 101")
            }
        }

    }
    
    @objc func createGroup() {
        
        guard FirebaseAccountManager.shared.userUID != nil else {
            
            let storyboard = UIStoryboard(name: "UserLogInStoryboard", bundle: nil)
            
            guard
                let loginVC = storyboard.instantiateViewController(withIdentifier: "UserLogInController")
                    as? UserLogInController
            else { return }
            
            loginVC.toNextVCHandler = { (UIAlertAction) in
                
                self.dismiss(animated: true, completion: nil)
            }
            
            loginVC.modalPresentationStyle = .fullScreen

            present(loginVC, animated: true, completion: nil)
            
            return
        }
        
        let storyboard = UIStoryboard(name: "CreateGroupStoryboard", bundle: nil)
        
        let createGroupVC = storyboard.instantiateViewController(withIdentifier: "CreateGroupController")
        
        createGroupVC.modalPresentationStyle = .overFullScreen
        
        present(createGroupVC, animated: false, completion: nil)
    }
    
    @objc func scanQRCode() {
        
        let qrCodeScannerVC = QRCodeScannerController()
        
        present(qrCodeScannerVC, animated: true, completion: nil)
    }
}

extension GroupListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return groupData.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell",
                                                 for: indexPath)
        
        guard let groupListCell = cell as? GroupListCell else { return cell }
        
        groupListCell.groupNameLabel.text = self.groupData[indexPath.row].name
        
        if !groupData[indexPath.row].isFinished {
        
            groupListCell.statusLabel.text = "進行中"
            
            groupListCell.statusLabel.textColor = .hexStringToUIColor()
        } else {
            
//            groupListCell.accessoryType = .none
            
            groupListCell.statusLabel.text = "已完成"

            groupListCell.statusLabel.textColor = .gray
        }
        
        guard let photoURLString = groupData[indexPath.row].photoURLString else {
            
            groupListCell.groupImage.image = UIImage(named: "UChu")
            
            return groupListCell
        }
        
        groupListCell.groupImage.setImage(urlString: photoURLString)
        
        return groupListCell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if groupData[indexPath.row].isFinished {
            
            // 如果有人完成騎乘，顯示結果頁面
            presentRidingResultViewController(indexPath)
            
        } else {
            
            // 如果尚未有人完成，顯示開始騎乘頁面
            showGroupDetailViewController(indexPath)
        }
    }
    
    private func showGroupDetailViewController(_ indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "GroupDetailStoryboard", bundle: nil)
        
        guard
            let detailVC = storyboard.instantiateViewController(withIdentifier: "GroupDetailViewController")
                as? GroupDetailViewController
        else { return }
        
        detailVC.groupData = self.groupData[indexPath.row]

        self.show(detailVC, sender: nil)
    }
    
    private func presentRidingResultViewController(_ indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "RidingResultStoryboard", bundle: nil)
        
        guard
            let resultVC = storyboard.instantiateViewController(withIdentifier: "RidingResultViewControllor")
            as? RidingResultViewController
        
        else { return }
        
        resultVC.groupData = self.groupData[indexPath.row]
        
//        self.show(resultVC, sender: nil)
        present(resultVC, animated: true, completion: nil)
    }
}

extension GroupListViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView,
//                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return 70
//    }
    
    // 退出群組
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        let groupID = groupData[indexPath.row].groupID
        
        guard let userUID = FirebaseAccountManager.shared.userUID else {
            
            return
        }
        
        FirebaseDataManeger.shared.removeUserFromGroup(groupID: groupID, userUID: userUID)

        groupData.remove(at: indexPath.row)

        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
