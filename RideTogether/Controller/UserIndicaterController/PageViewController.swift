//
//  PageViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/25.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate: class {

    func pageViewController(_ pageViewController: PageViewController,
                            didUpdateNumberOfPage numberOfPage: Int)
    
    func pageViewController(_ pageViewController: PageViewController,
                            didUpdatePageIndex pageIndex: Int)
}

class PageViewController: UIPageViewController {
    
    var viewControllerList = [UIViewController]()
    
    weak var pageViewControllerDelegate: PageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        delegate = self
        
        viewControllerList.append(getViewController(withStoryboardID: "FirstPageController"))
        
        viewControllerList.append(getViewController(withStoryboardID: "SecondPageController"))

        viewControllerList.append(getViewController(withStoryboardID: "ThirdPageController"))

        self.setViewControllers([self.viewControllerList.first!],
                                direction: UIPageViewController.NavigationDirection.forward,
                                animated: true, completion: nil)

    }
    
    private func getViewController(withStoryboardID storyboardID: String) -> UIViewController {
        return UIStoryboard(name: "UserIndicaterStoryboard",
                            bundle: nil).instantiateViewController(withIdentifier: storyboardID)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex: Int = viewControllerList.firstIndex(of: viewController)!
        
        let priviousIndex: Int = currentIndex - 1
        
        // 判斷上一頁的 index 是否小於 0，若小於 0 則停留在當前的頁數
        return priviousIndex < 0 ? nil : viewControllerList[priviousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex: Int = viewControllerList.firstIndex(of: viewController)!
        
        let nextIndex: Int = currentIndex + 1
        
        // 判斷下一頁的 index 是否大於總頁數，若大於則停留在當前的頁數
        return nextIndex > viewControllerList.count - 1 ? nil : viewControllerList[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {

         // 取得當前頁數的 viewController
        let currentViewController: UIViewController = (self.viewControllers?.first)!

        // 取得當前頁數的 index
        let currentIndex: Int = viewControllerList.firstIndex(of: currentViewController)!

        pageViewControllerDelegate?.pageViewController(self, didUpdatePageIndex: currentIndex)
    }
}
