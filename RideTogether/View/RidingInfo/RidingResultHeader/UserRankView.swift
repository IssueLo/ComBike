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
            
            userImageView.addRound(radius: Double(userImageView.bounds.width / 2))
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
        
        userNameLabel.alpha = 0
        
        userRankLabel.alpha = 0
        
        userSubRankLabel.alpha = 0

        userSpendTimeLabel.alpha = 0
        
        userNameLabel.text = userName
        
        userImageView.setImage(urlString: userImage)
        
        userRankLabel.text = String(userRank)
        
        userSubRankLabel.text = userSubRank
        
        userSpendTimeLabel.text = userSpendtime
        
        UIView.animate(withDuration: 1) {
            
            self.userNameLabel.alpha = 1
            
            self.userRankLabel.alpha = 1
                   
            self.userSubRankLabel.alpha = 1

            self.userSpendTimeLabel.alpha = 1
        }
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
