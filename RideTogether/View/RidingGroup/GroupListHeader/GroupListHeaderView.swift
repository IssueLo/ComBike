//
//  GroupListHeaderView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class GroupListHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var createDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = .white
    }
    
}
