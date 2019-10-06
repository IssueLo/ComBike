//
//  UserIndicatorController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/25.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class UserIndicatorController: UIViewController {
    
    let pageViewController = PageViewController.init(transitionStyle: .scroll,
                                                     navigationOrientation: .horizontal)
    
    lazy var tabBarViewController = TabBarViewController()
    
    @IBOutlet weak var launchScreen: UIView! {
        
        didSet {
            
            UIView.animate(withDuration: 1.2) {
                
                self.launchScreen.alpha = 0
            }
        }
    }

    @IBOutlet weak var skipBtn: UIButton! {
        
        didSet {
            
            skipBtn.addRound(backgroundColor: .hexStringToUIColor())
                        
            skipBtn.addTarget(self,
                              action: #selector(skipIndicatorVC),
                              for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl! {
        
        didSet {
                        
            pageControl.pageIndicatorTintColor = .lightGray
            
            pageControl.currentPageIndicatorTintColor = .hexStringToUIColor()
            
            pageControl.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
    
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // 手動 ContainerView
        setContainerView()
    }
    
    private func setContainerView() {
        
        self.addChild(pageViewController)
        
        pageViewController.pageViewControllerDelegate = self
        
        pageViewController.view.frame = containerView.frame

        containerView.addSubview(pageViewController.view)

        pageViewController.didMove(toParent: self)
    }
    
    @objc
    func skipIndicatorVC() {

        tabBarViewController.modalPresentationStyle = .fullScreen
        
        tabBarViewController.transitioningDelegate = self

        present(tabBarViewController, animated: true, completion: nil)
        
//        tabBarViewController.modalTransitionStyle = .crossDissolve
//
//        navigationController?.delegate = self
    }
}

extension UserIndicatorController: PageViewControllerDelegate {

    func pageViewController(_ pageViewController: PageViewController, didUpdateNumberOfPage numberOfPage: Int) {

        pageControl.numberOfPages = numberOfPage
    }

    func pageViewController(_ pageViewController: PageViewController, didUpdatePageIndex pageIndex: Int) {

        pageControl.currentPage = pageIndex
    }
}
// 轉場效果
extension UserIndicatorController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let transition = FadeOutTransition()
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        let transition = FadeOutTransition()
        
        return transition
    }
}

//extension UserIndicatorController: UINavigationControllerDelegate {
//
//    func navigationController(_ navigationController: UINavigationController,
//                              animationControllerFor operation: UINavigationController.Operation,
//                              from fromVC: UIViewController,
//                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        let transition = FadeOutTransition()
//
//        return transition
//    }
//}

//extension UserIndicatorController: UITabBarControllerDelegate {
//
//    func tabBarController(_ tabBarController: UITabBarController,
//                          animationControllerForTransitionFrom fromVC: UIViewController,
//                          to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        let transition = FadeOutTransition()
//
//        return transition
//    }
//}
