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
    
    case userIndicator = "UserIndicatorStoryboard"
    
    case routeList = "RouteListStoryboard"

    case areaRoute = "AreaRouteStoryboard"

    case routeDetail = "RouteDetailStoryboard"

    case groupList = "GroupListStoryboard"

    case createGroup = "CreateGroupStoryboard"
    
    case groupDetail = "GroupDetailStoryboard"
    
    case riding = "RidingStoryboard"
    
    case ridingResult = "RidingResultStoryboard"
    
    case userLogin = "UserLogInStoryboard"
    
    case userProfile = "UserProfileStoryboard"
    
    case privacyWeb = "PrivacyWebStoryboard"
    
    case qrCode = "QRCodeStoryboard"
    
    var get: UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
