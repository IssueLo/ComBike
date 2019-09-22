//
//  RouteHeaderView.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/18.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RouteHeaderView: UITableViewHeaderFooterView {
    
    var handler: (() -> Void)?
    
    @IBOutlet weak var routeAreaLabel: UILabel!
    
    @IBOutlet weak var seeAllRouteBtn: UIButton! {
        
        didSet {
            
            seeAllRouteBtn.setTitleColor(.hexStringToUIColor(), for: .normal)
        }
    }
    
    @IBAction func seeAllRoute(_ sender: UIButton) {
        
        handler!()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = .white
    }
    
}
