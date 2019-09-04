//
//  TabBarViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

private enum Tab {
    
    case lobby
    
    case ridingInfo
    
    case profile
    
    func callController() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .lobby: controller = UIStoryboard(name: "UserLogin",
                                               bundle: nil).instantiateInitialViewController()!
            
        case .ridingInfo: controller = UIStoryboard(name: "GroupStoryboard",
                                                    bundle: nil).instantiateInitialViewController()!
            
        case .profile: controller = UIStoryboard(name: "UserLogin",
                                                 bundle: nil).instantiateInitialViewController()!
            
        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
        
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .lobby:
            return UITabBarItem(title: nil,
                                image: UIImage(named: "Icons_36px_Home_Normal"),
                                selectedImage: UIImage(named: "Icons_36px_Home_Selected")
            )
            
        case .ridingInfo:
            return UITabBarItem(title: nil,
                                image: UIImage(named: "Icons_36px_Home_Normal"),
                                selectedImage: UIImage(named: "Icons_36px_Home_Selected")
            )
        
        case .profile:
            return UITabBarItem(title: nil,
                                image: UIImage(named: "Icons_36px_Profile_Normal"),
                                selectedImage: UIImage(named: "Icons_36px_Profile_Selected")
            )
        }
    }
}

class TabBarViewController: UITabBarController {
    
    private let tabs: [Tab] = [.lobby, .ridingInfo, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        viewControllers = tabs.map({ $0.callController() })
//        viewControllers = tabs.map({ (<#Tab#>) -> T in
//            <#code#>
//        })
        
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    
}
