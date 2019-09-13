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
        
        ridingResultHeaderView.setupHeaderView(groupResultInfo.name,
                                               FirebaseAccountManager.shared.userName!,
                                               1,
                                               "st",
                                               "00:00:00")
        
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
        
        let spendTime = TimeManager().secToRealTime(memberResultInfo[indexPath.row].spendTime!)
        
        ridingResultCell.memberNameLabel.text = memberResultInfo[indexPath.row].name
        
        ridingResultCell.rankingLabel.text = String(indexPath.row + 1)
        
        ridingResultCell.spendTimeLebal.text = spendTime
        
        self.updateUserInfo(memberResultInfo[indexPath.row].name,
                            (indexPath.row + 1),
                            spendTime)
        
        return ridingResultCell
    }
    
    func updateUserInfo(_ userName: String, _ userRank: Int, _ spendTime: String) {
        
        if userName == FirebaseAccountManager.shared.userName! {
            
            var userSubRank: String
            
            switch userRank {
            case 1: userSubRank = "st"
            case 2: userSubRank = "nd"
            case 3: userSubRank = "rd"
            default : userSubRank = "th"
            }
            
            self.ridingResultHeaderView.setupHeaderView(groupResultInfo.name,
                                                        userName,
                                                        userRank,
                                                        userSubRank,
                                                        spendTime)
            
        } else {
            
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
}

extension RidingResultViewController: UITableViewDelegate {
    
}
