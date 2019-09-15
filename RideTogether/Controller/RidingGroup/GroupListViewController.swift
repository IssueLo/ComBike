//
//  GroupViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
//import Firebase

class GroupListViewController: UIViewController {
    
    var groupData = [GroupData]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.groupListTableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var createGroupBtn: UIButton! {
        
        didSet {
            
            createGroupBtn.backgroundColor = .white
            
            createGroupBtn.layer.cornerRadius = 25
            
            createGroupBtn.layer.borderColor = UIColor.lightGray.cgColor
            
            createGroupBtn.layer.borderWidth = 1
            
            createGroupBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
            
            createGroupBtn.layer.shadowOpacity = 0.7
            
            createGroupBtn.layer.shadowRadius = 3
            
            createGroupBtn.layer.shadowColor = UIColor(red: 44.0/255.0,
                                                       green: 62.0/255.0,
                                                       blue: 80.0/255.0,
                                                       alpha: 1.0).cgColor
        }
    }
    
    @IBAction func createGroup() {
        
        guard FirebaseAccountManager.shared.userUID != nil else {
            
            let storyboard = UIStoryboard(name: "UserLogInStoryboard", bundle: nil)
            
            guard
                let loginVC = storyboard.instantiateViewController(withIdentifier: "UserLogInController")
                    as? UserLogInController
            else { return }
            
            loginVC.toNextVCHandler = { (UIAlertAction) in
                
                self.dismiss(animated: true, completion: nil)
            }

            present(loginVC, animated: true, completion: nil)
            
            return
        }
        
        let storyboard = UIStoryboard(name: "CreateGroupStoryboard", bundle: nil)
        
        let createGroupVC = storyboard.instantiateViewController(withIdentifier: "CreateGroupController")
        
        createGroupVC.modalPresentationStyle = .overFullScreen
        
        present(createGroupVC, animated: false, completion: nil)
    }

    @IBOutlet weak var groupListTableView: UITableView! {
       
        didSet {
            
            groupListTableView.contentInset.bottom = 100
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)

        groupListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(scanQRCode))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uesrUID = FirebaseAccountManager.shared.userUID else {
            
            groupData = []
            
            return
        }
        
        if groupData.count == 0 {
            
            creatObserverOfGroup(uesrUID: uesrUID)
        }
        
        // User 登入且群組資料為空的情況下建立監聽
//        guard
//            let uesrUID = FirebaseAccountManager.shared.userUID,
//            groupData.count == 0
//        else { return }
        
        // 監聽 GroupData
//        creatObserverOfGroup(uesrUID: uesrUID)
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
        
        present(resultVC, animated: true, completion: nil)
    }
}

extension GroupListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        groupData.remove(at: indexPath.row)

        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
