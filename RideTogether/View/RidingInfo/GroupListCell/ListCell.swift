//
//  GroupListCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    var groupData: GroupData? {
        
        didSet {
            
            groupNameLabel.text = groupData?.name

            if let isFinished = groupData?.isFinished {
                
                if isFinished {
                    
                    statusLabel.text = "已完成"
                    
                    statusLabel.textColor = .gray
                    
                } else {
                    
                    statusLabel.text = "進行中"
                    
                    statusLabel.textColor = .hexStringToUIColor()
                }
                
            } else {
                
                statusLabel.alpha = 0
                
                return
            }
            
            if let photoURLString = groupData?.photoURLString {
                
                groupImage.setImage(urlString: photoURLString)
                
            } else {
                
                groupImage.image = UIImage.setIcon(.UChu)
            }
        }
    }
    
    @IBOutlet weak var groupImage: UIImageView! {
        
        didSet {
            
            groupImage.addRound(radius: Double(groupImage.bounds.width / 2),
                                borderWidth: 0.7,
                                borderColor: .black)
        }
    }
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
