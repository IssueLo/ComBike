//
//  GroupViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import Firebase

class GroupListViewController: UIViewController {
    
    var groupInfoArray: [GroupInfo] = [] {
        
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
        
        guard Auth.auth().currentUser?.uid != nil else {
            
            let storyboard = UIStoryboard(name: "UserLogInStoryboard", bundle: nil)
            
            let loginVC = storyboard.instantiateViewController(withIdentifier: "UserLogInController")
            
            //            loginVC.modalPresentationStyle = .overCurrentContext
            //
            present(loginVC, animated: true, completion: nil)
            
            //            show(loginVC, sender: nil)
            
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
        
        // 記得改回去喔！
        UserInfo.uid = "ytjZE12xhheXDTnxBvc8zOUCkS93"

        UserInfo.name = "Ruyu"

        UserInfo.uid = "userID"

        UserInfo.name = "Kevin"
        
//        UserInfo.uid = "12345678"
//
//        UserInfo.name = "Nick"
        
        // 有登入的情況可以搜尋群組資料
//        if UserInfo.uid != nil {
//
////            FirebaseDataManeger.shared.searchUserGroup(self, UserInfo.uid!)
//
//            creatObserverOfGroup(UserInfo.uid!)
//        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(scanQRCode))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserInfo.uid != nil && groupInfoArray.count == 0 {
            
            creatObserverOfGroup(UserInfo.uid!)
        }
    }
    
    @objc func scanQRCode() {
        
        let qrCodeScannerVC = QRCodeScannerController()
        
        present(qrCodeScannerVC, animated: true, completion: nil)
    }
    
    func creatObserverOfGroup(_ userID: String) {
        
        FirebaseDataManeger.shared.observerOfGroup(self, userID, handler: {
            
        })
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
        
        return 70
    }
}
