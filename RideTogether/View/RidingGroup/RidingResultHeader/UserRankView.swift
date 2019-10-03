//
//  UserRankView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/16.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class UserRankView: UIView {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView! {
        
        didSet {
            
            userImageView.addRound(radis: Double(userImageView.bounds.width / 2))
        }
    }
    
    @IBOutlet weak var userRankLabel: UILabel!
    
    @IBOutlet weak var userSubRankLabel: UILabel!
    
    @IBOutlet weak var userSpendTimeLabel: UILabel!
    
    func setupUserRankView(_ userName: String,
                           _ userImage: String,
                           _ userRank: Int,
                           _ userSubRank: String,
                           _ userSpendtime: String) {
        
        userNameLabel.text = userName
        
        userImageView.setImage(urlString: userImage)
        
        userRankLabel.text = String(userRank)
        
        userSubRankLabel.text = userSubRank
        
        userSpendTimeLabel.text = userSpendtime
    }
    
    func setupUserRankView(_ userName: String,
                           _ userRank: Int,
                           _ userSubRank: String,
                           _ userSpendtime: String) {
        
        userNameLabel.text = userName
        
        userImageView.image = UIImage(named: "UChu")
                
        userRankLabel.text = String(userRank)
        
        userSubRankLabel.text = userSubRank
        
        userSpendTimeLabel.text = userSpendtime
    }
}
