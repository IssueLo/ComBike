//
//  FadeOutTransition.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/26.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation
import UIKit

class FadeOutTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 1.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from) as? UserIndicaterController
        let fromView = fromVC?.view
        
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC?.view
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView!)
        containerView.addSubview(toView!)
        
        // 轉場動畫
        toView?.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            
            fromVC?.skipBtn.setTitle("", for: .normal)
                        
            fromVC?.skipBtn.translatesAutoresizingMaskIntoConstraints = true
            
//            fromVC?.skipBtn.clipsToBounds = true

            fromVC?.skipBtn.frame = CGRect(x: -30,
                                           y: -30,
                                           width: UIScreen.main.bounds.width + 60,
                                           height: UIScreen.main.bounds.height + 60)
            
        }, completion: { finished in
            UIView.animate(withDuration: 0.8, animations: {
                toView?.alpha = 1
                
            }, completion: { finished in
                
                // 通知完成轉場
                transitionContext.completeTransition(true)
            })
        })
    }
}


class StartFadeOutTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var handler: (() -> Void)!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 1.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from) //as? GroupDetailViewController
        let fromView = fromVC?.view
        
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC?.view
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView!)
        containerView.addSubview(toView!)
        
        // 轉場動畫
        toView?.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            
            self.handler()
            
        }, completion: { finished in
            UIView.animate(withDuration: 0.8, animations: {
                toView?.alpha = 1
                
            }, completion: { finished in
                
                // 通知完成轉場
                transitionContext.completeTransition(true)
            })
        })
    }
}
