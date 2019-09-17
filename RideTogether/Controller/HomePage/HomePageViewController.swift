//
//  HomePageViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    var jsonArray: NSMutableArray?
    
    var routeDataArray = [RouteData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tokenURL = StravaRequest.getToken.makeRequest()
        
        HTTPClient.shared.tokenRequest(tokenURL)
    }
}
