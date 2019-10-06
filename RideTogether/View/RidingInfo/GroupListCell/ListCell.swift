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
                                borderWidth: 0.3,
                                borderColor: .gray)
        }
    }
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
