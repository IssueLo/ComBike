//
//  GroupDetailViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {
    
    var groupData: GroupData!
    
    var memberData = [MemberData]() {
        
        didSet {
            
            memberListTableView.reloadData()
        }
    }
    
    @IBOutlet weak var memberListTableView: UITableView!
    
    @IBOutlet weak var startBtn: UIButton! {
        
        didSet {
            
            startBtn.backgroundColor = .white

            startBtn.layer.cornerRadius = 25
            
            startBtn.layer.borderColor = UIColor.lightGray.cgColor
            
            startBtn.layer.borderWidth = 1
            
            startBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
            
            startBtn.layer.shadowOpacity = 0.7
            
            startBtn.layer.shadowRadius = 5
            
            startBtn.layer.shadowColor = UIColor(red: 44.0/255.0,
                                                 green: 62.0/255.0,
                                                 blue: 80.0/255.0,
                                                 alpha: 1.0).cgColor
        }
    }
    
    @IBAction func startRiding() {
        
        let storyboard = UIStoryboard.init(name: "RidingStoryboard", bundle: nil)
        
        guard
            let ridingVC = storyboard.instantiateViewController(withIdentifier: "RidingViewController")
            as? RidingViewController
        else { return }

        ridingVC.groupData = groupData
        
        present(ridingVC, animated: true, completion: nil)
//        show(ridingVC, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = groupData.name
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)
        
        memberListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icons_QRCode"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showQRCodeVC))
        
        creatObserverOfMember(groupID: groupData.groupID)
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
    
    func creatObserverOfMember(groupID: String) {
        
        FirebaseDataManeger.shared.observerForMemberData(groupID) { [weak self](result) in
            
            switch result {
                
            case .success(let memberData):
                
                self?.memberData.append(memberData)
                
            case .failure:
                
                self?.showAlert("GroupDetailVC - 101")
            }
        }
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
                
        return groupListCell
    }
}

extension GroupDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
}
