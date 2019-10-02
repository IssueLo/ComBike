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
            
        case .lobby: controller = StoryboardCategory.routeList.getStoryboard().instantiateInitialViewController()!
            
        case .ridingInfo: controller = StoryboardCategory.group.getStoryboard().instantiateInitialViewController()!
            
        case .profile: controller = StoryboardCategory.uesrProfile.getStoryboard().instantiateInitialViewController()!
            
        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)
                
        return controller
    }
    
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .lobby:
            return UITabBarItem(title: nil,
                                image: UIImage.setIcon(.Icons_Recommend),
                                selectedImage: UIImage.setIcon(.Icons_Recommend)
            )
            
        case .ridingInfo:
            return UITabBarItem(title: nil,
                                image: UIImage.setIcon(.Icons_BicycleRider),
                                selectedImage: UIImage.setIcon(.Icons_BicycleRider)
            )
        
        case .profile:
            return UITabBarItem(title: nil,
                                image: UIImage.setIcon(.Icons_Biker),
                                selectedImage: UIImage.setIcon(.Icons_Biker)
            )
        }
    }
}

class TabBarViewController: UITabBarController {
    
    private let tabs: [Tab] = [.lobby, .ridingInfo, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 不支援暗黑模式
        overrideUserInterfaceStyle = .light
        
        delegate = self
        
        UserDefaults.standard.setValue(true, forKey: "UserLogined")
                
        viewControllers = tabs.map({ $0.callController() })
//        viewControllers = tabs.map({ (<#Tab#>) -> T in
//            <#code#>
//        })
        
        guard let userUID = FirebaseAccountManager.shared.userUID else { return }
        
        FirebaseDataManeger.shared.searchUserInfo(userUID)
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
        guard FirebaseAccountManager.shared.userUID != nil else {

            let storyboard = StoryboardCategory.userLogin.getStoryboard()
            
            guard let loginVC = storyboard.instantiateViewController(withIdentifier: UserLogInController.identifier)
                as? UserLogInController
            else {
                return false
            }
            
            loginVC.toNextVCHandler = { (UIAlertAction) in
                
                tabBarController.selectedIndex = 2
                
                self.dismiss(animated: true, completion: nil)
            }
            
            loginVC.modalPresentationStyle = .fullScreen

            present(loginVC, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
}
