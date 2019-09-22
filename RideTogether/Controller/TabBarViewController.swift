//
//  TabBarViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import FirebaseAuth

private enum Tab {
    
    case lobby
    
    case ridingInfo
    
    case profile
    
    func callController() -> UIViewController {
        
        var controller: UIViewController
        
        switch self {
            
        case .lobby: controller = UIStoryboard(name: "HomePageStoryboard",
                                               bundle: nil).instantiateInitialViewController()!
            
        case .ridingInfo: controller = UIStoryboard(name: "GroupStoryboard",
                                                    bundle: nil).instantiateInitialViewController()!
            
        case .profile: controller = UIStoryboard(name: "UserProfileStoryboard",
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
                                image: UIImage(named: "Icons_Recommend"),
                                selectedImage: UIImage(named: "Icons_Recommend")
            )
            
        case .ridingInfo:
            return UITabBarItem(title: nil,
                                image: UIImage(named: "Icons_BicycleRider"),
                                selectedImage: UIImage(named: "Icons_BicycleRider")
            )
        
        case .profile:
            return UITabBarItem(title: nil,
                                image: UIImage(named: "Icons_Biker"),
                                selectedImage: UIImage(named: "Icons_Biker")
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
        
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        FirebaseDataManeger.shared.searchUserInfo(userUID)
        
        print(Auth.auth().currentUser?.uid as Any)
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        
        guard
            let navigationVC = viewController as? UINavigationController,
            navigationVC.viewControllers.first is UserProfileController
        else { return true }
        
        // 確認是否有登入會員
        guard Auth.auth().currentUser?.uid != nil else {

            let storyboard = UIStoryboard(name: "UserLogInStoryboard", bundle: nil)
            
            guard let loginVC = storyboard.instantiateViewController(withIdentifier: "UserLogInController")
                as? UserLogInController
            else {
                return false
            }
            
            loginVC.toNextVCHandler = { (UIAlertAction) in
                
                tabBarController.selectedIndex = 2
                
                self.dismiss(animated: true, completion: nil)
            }

            present(loginVC, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
}
