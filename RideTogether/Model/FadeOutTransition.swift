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
        
        return 1.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = fromVC?.view
        
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC?.view
        
        let containerView = transitionContext.containerView
        containerView.addSubview(fromView!)
        containerView.addSubview(toView!)
        
        // 轉場動畫
        toView?.alpha = 0
        UIView.animate(withDuration: 0.8, animations: {
            fromView?.alpha = 0
            
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
