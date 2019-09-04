//
//  GroupViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    var groupNameArray = ["新竹一日遊", "淡水八里", "基隆北海岸"]
    
    var groupInfoArray: [GroupInfo] = [] {
        
        didSet {
            
            groupListTableView.reloadData()
        }
    }
    
    @IBAction func createGroup() {
        
        let storyboard = UIStoryboard(name: "CreateGroupStoryboard", bundle: nil)
        
        let createGroupVC = storyboard.instantiateViewController(withIdentifier: "CreateGroupController")
        
        createGroupVC.modalPresentationStyle = .overCurrentContext
        
        present(createGroupVC, animated: false, completion: nil)
    }
    
    @IBOutlet weak var groupListTableView: UITableView! {
        didSet {
//            
//            let nib = UINib(nibName: "groupListCell", bundle: nil)
//
//            groupListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)

        groupListTableView.register(nib, forCellReuseIdentifier: "groupListCell")
        
        if UserInfo.uid != nil {
            
            FirebaseDataManeger.shared.searchUserGroup(self, UserInfo.uid!)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension GroupViewController: UITableViewDataSource {
    
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
        
        showGroupDetailViewController(indexPath)
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
}

extension GroupViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
