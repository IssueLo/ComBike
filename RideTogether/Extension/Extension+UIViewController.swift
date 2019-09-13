//
//  extansion.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func backToRoot(completion: (() -> Void)? = nil) {
        
        if presentingViewController != nil {
            
            let superVC = presentingViewController
            
            dismiss(animated: false, completion: nil)
            
            superVC?.backToRoot(completion: completion)
            
            return
        }
        
//        if self is UITabBarController {
//
//            let vc = (self as? UITabBarController)?.selectedViewController
//
//            vc?.backToRoot(completion: completion)
//
//            return
//        }
        
        if self is UINavigationController {
            // swiftlint:disable force_cast
            (self as! UINavigationController).popToRootViewController(animated: false)
            // swiftlint:enable force_cast
        }
        
        completion?()
    }
    
    func showAlert(_ message: String, _ handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確定", style: .default, handler: handler)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
