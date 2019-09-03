//
//  GroupDetailViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {
    
    @IBOutlet weak var memberListTableView: UITableView!
    
    @IBAction func startRiding() {
        
        let storyboard = UIStoryboard.init(name: "RidingStoryboard", bundle: nil)
        
        guard let ridingVC = storyboard.instantiateViewController(withIdentifier: "RidingViewController") as? RidingViewController else { return }
        
        ridingVC.groupName = navigationTitle
//        show(ridingVC, sender: nil)
        present(ridingVC, animated: true, completion: nil)
    }
    
    var navigationTitle: String!
    
    var nameArray = ["Kevin", "Ruyu", "Peter"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navigationTitle
        
        let nib = UINib(nibName: "GroupListCell", bundle: nil)
        
        memberListTableView.register(nib, forCellReuseIdentifier: "groupListCell")

    }
    
}

extension GroupDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupListCell", for: indexPath)
        
        guard let groupListCell = cell as? GroupListCell else { return cell }
        
        groupListCell.groupNameLabel.text = self.nameArray[indexPath.row]
        
        return groupListCell
    }
    
}

extension GroupDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
