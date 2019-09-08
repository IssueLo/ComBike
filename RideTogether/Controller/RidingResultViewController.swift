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
    
    var member = ["Kevin", "Ruyu", "Peter"]
    
    var groupResultInfo: GroupInfo!
    
    var groupName: String!
    
    @IBOutlet weak var ridingResultTableView: UITableView!
    
//    @IBAction func backToGroupList() {
//        
//        dismiss(animated: true, completion: nil)
//        
//        backToRoot()
////        navigationController?.popToRootViewController(animated: true)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let nib = UINib(nibName: "RidingResultCell", bundle: nil)
        
        ridingResultTableView.register(nib, forCellReuseIdentifier: "RidingResultCell")
        
//        let headerNib = UINib(nibName: "RidingResultHeader", bundle: nil)
//
//        ridingResultTableView.register(headerNib,
//                                       forHeaderFooterViewReuseIdentifier: "RidingResultHeader")
        
        ridingResultHeaderView.setupHeaderView(groupResultInfo.name, UserInfo.name!, 2, "nd", "01:03:14")
        
        ridingResultHeaderView.handler = {
            
            self.dismiss(animated: true, completion: nil)
            
            self.backToRoot()
        }
    }

}

extension RidingResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return member.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ridingResultTableView.dequeueReusableCell(withIdentifier: "RidingResultCell", for: indexPath)
        
        guard let ridingResultCell = cell as? RidingResultCell else { return cell }
        
        ridingResultCell.memberNameLabel.text = member[indexPath.row]
        
        ridingResultCell.rankingLabel.text = String(indexPath.row + 1)
        
        return ridingResultCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
}

extension RidingResultViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        guard
//            let headerView = ridingResultTableView.dequeueReusableHeaderFooterView(withIdentifier: "RidingResultHeader")
//                as? RidingResultHeader
//            
//        else { return UIView() }
//        
//        headerView.userNameLabel.text = UserInfo.name
//        
//        return headerView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//        return 100
//    }
}
