//
//  Extension+UIStoryboard.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/2.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

enum StoryboardCategory: String {
    
    case tabBar = "TabBarStoryboard"
    
    case userIndicater = "UserIndicaterStoryboard"
    
    case routeList = "RouteListStoryboard"

    case areaRoute = "AreaRouteStoryboard"

    case routeDetail = "RouteDetailStoryboard"

    case groupList = "GroupListStoryboard"

    case createGroup = "CreateGroupStoryboard"
    
    case groupDetail = "GroupDetailStoryboard"
    
    case riding = "RidingStoryboard"
    
    case ridingResult = "RidingResultStoryboard"
    
    case userLogin = "UserLogInStoryboard"
    
    case uesrProfile = "UserProfileStoryboard"
    
    case privacyWeb = "PrivacyWebStoryboard"
    
    case qrCode = "QRCodeStoryboard"
    
    func getStoryboard() -> UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
