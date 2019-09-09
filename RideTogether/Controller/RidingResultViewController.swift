//
//  RidingResultViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RidingResultViewController: UIViewController {
    
    @IBOutlet weak var ridingResultHeaderView: RidingResultHeaderView!
    
    var groupResultInfo: GroupInfo!
    
    var memberResultInfo: [MemberInfo] = [] {
        
        didSet {
            
            ridingResultTableView.reloadData()
        }
    }
    
    var groupName: String!
    
    @IBOutlet weak var ridingResultTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let nib = UINib(nibName: "RidingResultCell", bundle: nil)
        
        ridingResultTableView.register(nib, forCellReuseIdentifier: "RidingResultCell")
        
        ridingResultHeaderView.setupHeaderView(groupResultInfo.name, UserInfo.name!, 1, "st", "00:00:00")
        
        ridingResultHeaderView.handler = {
            
            self.dismiss(animated: true, completion: nil)
            
            self.backToRoot()
        }
        
        FirebaseDataManeger.shared.observerOfResult(self, groupResultInfo.groupID)
    }

}

extension RidingResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberResultInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ridingResultTableView.dequeueReusableCell(withIdentifier: "RidingResultCell", for: indexPath)
        
        guard let ridingResultCell = cell as? RidingResultCell else { return cell }
        
        ridingResultCell.memberNameLabel.text = memberResultInfo[indexPath.row].name
        
        ridingResultCell.rankingLabel.text = String(indexPath.row + 1)
        
        ridingResultCell.spendTimeLebal.text = TimeManager().secToRealTime(memberResultInfo[indexPath.row].spendTime!)
        
        return ridingResultCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
}

extension RidingResultViewController: UITableViewDelegate {
    
}
