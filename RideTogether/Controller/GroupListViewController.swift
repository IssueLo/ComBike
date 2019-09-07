//
//  GroupViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController {
    
    var groupInfoArray: [GroupInfo] = [] {
        
        didSet {
            
            groupListTableView.reloadData()
        }
    }
    
    @IBAction func createGroup() {
        
        let storyboard = UIStoryboard(name: "CreateGroupStoryboard", bundle: nil)
        
        let createGroupVC = storyboard.instantiateViewController(withIdentifier: "CreateGroupController")
        
        createGroupVC.modalPresentationStyle = .overFullScreen
        
        present(createGroupVC, animated: false, completion: nil)
    }
    
    @IBAction func scanQRCode() {
        
        let qrCodeScannerVC = QRCodeScannerController()
        
        present(qrCodeScannerVC, animated: false, completion: nil)
    }
    
    @IBOutlet weak var groupListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)

        groupListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        
        // 記得改回去喔！
        UserInfo.uid = "1111111111111"
        
        UserInfo.name = "Ruyu"
        
        // 有登入的情況可以搜尋群組資料
        if UserInfo.uid != nil {

            FirebaseDataManeger.shared.searchUserGroup(self, UserInfo.uid!)
        }
    }
}

extension GroupListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell", for: indexPath)
        
        guard let groupListCell = cell as? GroupListCell else { return cell }
        
        groupListCell.groupNameLabel.text = self.groupInfoArray[indexPath.row].name
        
        return groupListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if groupInfoArray[indexPath.row].memberInfo[0].route == nil {
            
            // 如果沒有騎乘紀錄，顯示開始騎乘頁面
            showGroupDetailViewController(indexPath)
            
        } else {
            
            // 如果有騎乘紀錄，顯示結果頁面
            presentRidingResultViewController(indexPath)
        }
    }
    
    private func showGroupDetailViewController(_ indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "GroupDetailStoryboard", bundle: nil)
        
        guard
            let detailVC = storyboard.instantiateViewController(withIdentifier: "GroupDetailViewController")
                as? GroupDetailViewController
        else { return }
        
        detailVC.groupInfo = self.groupInfoArray[indexPath.row]
        
//        guard let detailVC = vc as? ProductDetailViewController else { return }
//
//        detailVC.product = product

        self.show(detailVC, sender: nil)
    }
    
    private func presentRidingResultViewController(_ indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "RidingResultStoryboard", bundle: nil)
        
        guard
            let resultVC = storyboard.instantiateViewController(withIdentifier: "RidingResultViewControllor")
            as? RidingResultViewController
        
        else { return }
        
        resultVC.groupResultInfo = self.groupInfoArray[indexPath.row]
        
        present(resultVC, animated: true, completion: nil)
    }
}

extension GroupListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
