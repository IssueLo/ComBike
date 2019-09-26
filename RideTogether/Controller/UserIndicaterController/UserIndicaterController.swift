//
//  UserIndicaterController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/25.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class UserIndicaterController: UIViewController {
    
    @IBOutlet weak var launchScreen: UIView! {
        
        didSet {
            
            UIView.animate(withDuration: 1.2) {
                
                self.launchScreen.alpha = 0
            }
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var skipBtn: UIButton! {
        
        didSet {
            
            skipBtn.addRound(backgroundColor: .hexStringToUIColor())
        }
    }
    
    let pageViewController = PageViewController.init(transitionStyle: .scroll,
                                                     navigationOrientation: .horizontal)
            
    @IBOutlet weak var pageControl: UIPageControl! {
        
        didSet {
                        
            pageControl.pageIndicatorTintColor = .lightGray
            
            pageControl.currentPageIndicatorTintColor = .hexStringToUIColor()
            
            pageControl.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 手動 ContainerView
        self.addChild(pageViewController)
        
        pageViewController.view.frame = containerView.frame
        
        containerView.addSubview(pageViewController.view)
        
        pageViewController.didMove(toParent: self)
        
        pageViewController.pageViewControllerDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
}

extension UserIndicaterController: PageViewControllerDelegate {

    func pageViewController(_ pageViewController: PageViewController, didUpdateNumberOfPage numberOfPage: Int) {

//        pageControl.numberOfPages = numberOfPage
    }

    func pageViewController(_ pageViewController: PageViewController, didUpdatePageIndex pageIndex: Int) {

        pageControl.currentPage = pageIndex
    }
}
