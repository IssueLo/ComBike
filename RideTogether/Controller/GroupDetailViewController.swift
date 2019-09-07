//
//  GroupDetailViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {
    
    var groupInfo: GroupInfo!
    
    @IBOutlet weak var memberListTableView: UITableView!
    
    @IBAction func startRiding() {
        
        let storyboard = UIStoryboard.init(name: "RidingStoryboard", bundle: nil)
        
        guard
            let ridingVC = storyboard.instantiateViewController(withIdentifier: "RidingViewController")
            as? RidingViewController
        else { return }
        
//        ridingVC.groupName = groupInfo.name
        
        ridingVC.groupInfo = groupInfo
//        show(ridingVC, sender: nil)
        present(ridingVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = groupInfo.name
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)
        
        memberListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showQRCodeVC))
    }
    
    @objc func showQRCodeVC() {
        
        let storyboard = UIStoryboard.init(name: "QRCodeStoryboard", bundle: nil)
        
        guard let qrCodeVC = storyboard.instantiateViewController(withIdentifier: "QRCodeViewController")
            as? QRCodeViewController
        else { return }
        
        qrCodeVC.groupID = groupInfo.groupID
        
        qrCodeVC.modalPresentationStyle = .overFullScreen
        
        present(qrCodeVC, animated: false, completion: nil)
    }
    
}

extension GroupDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupInfo.memberInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell", for: indexPath)
        
        guard let groupListCell = cell as? GroupListCell else { return cell }
        
        groupListCell.groupNameLabel.text = self.groupInfo.memberInfo[indexPath.row].name
        
        return groupListCell
    }
    
}

extension GroupDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
