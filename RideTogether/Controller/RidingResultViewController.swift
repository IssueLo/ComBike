//
//  RidingResultViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RidingResultViewController: UIViewController {
    
    var member = ["Kevin", "Ruyu", "Peter"]
    
    @IBOutlet weak var groupNameLabel: UILabel! {
        didSet {
            
            groupNameLabel.text = groupName
        }
    }
    
    var groupName: String!
    
    @IBOutlet weak var ridingResultTableView: UITableView!
    
    @IBAction func backToGroupList() {
        
//        dismiss(animated: true, completion: nil)
        
        backToRoot()
//        navigationController?.popToRootViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let nib = UINib(nibName: "RidingResultCell", bundle: nil)
        
        ridingResultTableView.register(nib, forCellReuseIdentifier: "RidingResultCell")
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
        
        return ridingResultCell
    }
    
}

extension RidingResultViewController: UITableViewDelegate {
    
}
