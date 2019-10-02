//
//  extansion.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
    func showAlert(_ message: String, _ handler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "確定", style: .default, handler: handler)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func backToRoot(completion: (() -> Void)? = nil) {
        
        if self is UITabBarController {

            let currnetVC = (self as? UITabBarController)?.selectedViewController

            currnetVC?.backToRoot(completion: completion)

            return
        }
        
        if self is UINavigationController {
            // swiftlint:disable force_cast
            (self as! UINavigationController).popToRootViewController(animated: true)
            // swiftlint:enable force_cast
        }
        
        if presentingViewController != nil {
            
            if presentingViewController is UserIndicaterController {
                
                return
            }

            let superVC = presentingViewController
            
            if self is RidingResultViewController {
                
                dismiss(animated: true, completion: nil)
            }

            dismiss(animated: false, completion: nil)

            superVC?.backToRoot(completion: completion)

            return
        }
        
        completion?()
    }
}
