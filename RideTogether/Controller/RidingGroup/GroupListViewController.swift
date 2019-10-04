//
//  GroupViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController {
    
    var rawGroupData = [GroupData]() {
        
        didSet {
            
            if rawGroupData.count == 0 {
                
                remindBackView.alpha = 1
                
            } else {
                
                remindBackView.alpha = 0
            }
            
//            sortedGroupData = GroupSortingManager.sortingByDate(groupData: rawGroupData)
            
            sortedGroupData = rawGroupData.sorted { $0.createTime.seconds > $1.createTime.seconds }
        }
    }

    var sortedGroupData = [GroupData]() {

        didSet {

            separatedGroupData = GroupSortingManager.separatedGroupData(sortedGroupData: sortedGroupData)
        }
    }
    
    var separatedGroupData = [[GroupData]]() {
        
        didSet {
            
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
                        
            createGroupBtn.addTarget(self,
                                     action: #selector(createGroup),
                                     for: .touchUpInside)
        }
    }

    @IBOutlet weak var groupListTableView: UITableView! {
       
        didSet {

            groupListTableView.contentInset.bottom = 12
            
            groupListTableView.contentInset.top = 12
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)

        groupListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        
        let headerNib = UINib(nibName: "GroupListHeaderView", bundle: nil)

        groupListTableView.register(headerNib,
                                    forHeaderFooterViewReuseIdentifier: "GroupListHeaderView")
        
        setNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.tabBarController?.tabBar.isHidden = false
        
        if let userUID = FirebaseAccountManager.shared.userUID {
            // 登入且 groupData 資料為 0，建立監聽
            if rawGroupData.count == 0 {
                
                createObserverOfGroup(userUID: userUID)
            }
            
        } else {
            // 登出狀態清空 groupData 資料
            rawGroupData = []
        }
    }
    
    private func setNavigationItem() {
        
        let createGroupIcon = UIBarButtonItem(image: UIImage(named: "Icons_CreateGroup"),
                                             style: .done,
                                             target: self,
                                             action: #selector(createGroup))
        
        let scanIcon = UIBarButtonItem(image: UIImage(named: "Icons_QRCodeScan"),
                                       style: .done,
                                       target: self,
                                       action: #selector(scanQRCode))
        
        navigationItem.rightBarButtonItems = [scanIcon, createGroupIcon]
    }
    
    private func createObserverOfGroup(userUID: String) {
        
        FirebaseDataManeger.shared.observerForGroupData(userUID) { [weak self] (result) in

            switch result {
                
            case .success(let groupData):
                
                // 要判斷是新的群組，還是修改原有群組
                if self?.rawGroupData.count != 0 {
                    
                    guard let groupDataCount = self?.rawGroupData.count else { return }
                    
                    for number in 0..<groupDataCount {
                        
                        if groupData.groupID == self?.rawGroupData[number].groupID {
                            
                            self?.rawGroupData.remove(at: number)
                            
                            self?.rawGroupData.insert(groupData, at: number)
                            
                            return
                        } else {
                            
                            continue
                        }
                    }
                }
                                
                self?.rawGroupData.append(groupData)
                
            case .failure:
                
                self?.showAlert("GroupDetailVC - 101")
            }
        }

    }
    
    @objc
    func createGroup() {
        // 由 Model 判斷
        if FirebaseAccountManager.shared.userUID == nil {
            
            let storyboard = StoryboardCategory.userLogin.getStoryboard()
            
            guard
                let loginVC = storyboard.instantiateViewController(
                    withIdentifier: UserLogInController.identifier
                    ) as? UserLogInController

            else { return }
            
            loginVC.toNextVCHandler = { (UIAlertAction) in
                
                self.dismiss(animated: true)
            }
            
            loginVC.modalPresentationStyle = .fullScreen

            present(loginVC, animated: true)
            
        } else {
            
            let storyboard = StoryboardCategory.createGroup.getStoryboard()
            
            let createGroupVC = storyboard.instantiateViewController(
                withIdentifier: CreateGroupController.identifier
            )
            
            createGroupVC.modalPresentationStyle = .overFullScreen
            
            present(createGroupVC, animated: false)
        }
    }
    
    @objc
    func scanQRCode() {
        
        let qrCodeScannerVC = QRCodeScannerController()
        
        qrCodeScannerVC.modalPresentationStyle = .fullScreen
        
        present(qrCodeScannerVC, animated: true, completion: nil)
    }
}

extension GroupListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return separatedGroupData.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        return separatedGroupData[section].count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell",
                                                 for: indexPath)
        
        guard let groupListCell = cell as? GroupListCell else {
            
            return cell
        }
        
        let groupData = separatedGroupData[indexPath.section][indexPath.row]
        
        groupListCell.groupNameLabel.text = groupData.name
        
        if groupData.isFinished {
        
            groupListCell.statusLabel.text = "已完成"
            
            groupListCell.statusLabel.textColor = .gray
            
        } else {
            
            groupListCell.statusLabel.text = "進行中"
            
            groupListCell.statusLabel.textColor = .hexStringToUIColor()
        }
        
        if let photoURLString = groupData.photoURLString {
            
            groupListCell.groupImage.setImage(urlString: photoURLString)
            
        } else {
            
            groupListCell.groupImage.image = UIImage(named: "UChu")
        }
                
        return groupListCell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let groupData = separatedGroupData[indexPath.section][indexPath.row]
        
        if groupData.isFinished {
            // 如果有人完成騎乘，顯示結果頁面
            presentRidingResultViewController(indexPath)
            
        } else {
            // 如果尚未有人完成，顯示開始騎乘頁面
            showGroupDetailViewController(indexPath)
        }
    }
    
    private func showGroupDetailViewController(_ indexPath: IndexPath) {
        
        let storyboard = StoryboardCategory.groupDetail.getStoryboard()
        
        guard
            let detailVC = storyboard.instantiateViewController(
                withIdentifier: GroupDetailViewController.identifier
                ) as? GroupDetailViewController
            
        else { return }
        
        detailVC.groupData = separatedGroupData[indexPath.section][indexPath.row]

        self.show(detailVC, sender: nil)
    }
    
    private func presentRidingResultViewController(_ indexPath: IndexPath) {
        
        let storyboard = StoryboardCategory.ridingResult.getStoryboard()
        
        guard
            let resultVC = storyboard.instantiateViewController(
                withIdentifier: RidingResultViewController.identifier
                ) as? RidingResultViewController
        
        else { return }
        
        resultVC.groupData = separatedGroupData[indexPath.section][indexPath.row]
        
        resultVC.modalPresentationStyle = .fullScreen

        present(resultVC, animated: true)
    }
}

extension GroupListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "GroupListHeaderView"
            ) as? GroupListHeaderView
        
        let createTime = Int(separatedGroupData[section][0].createTime.seconds)
        
        headerView?.createDateLabel.text = DateManager.secondToDate(seconds: createTime)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 48
    }
    
    // 退出群組
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        let groupID = separatedGroupData[indexPath.section][indexPath.row].groupID
        
        if let userUID = FirebaseAccountManager.shared.userUID {
            
            FirebaseDataManeger.shared.removeUserFromGroup(groupID: groupID,
                                                           userUID: userUID)
        }
        
        if separatedGroupData[indexPath.section].count == 1 {
            
            separatedGroupData.remove(at: indexPath.section)
            
        } else {

            separatedGroupData[indexPath.section].remove(at: indexPath.row)
        }
    }
}
