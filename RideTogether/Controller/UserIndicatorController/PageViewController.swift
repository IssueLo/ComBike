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

// swiftlint:disable force_cast
class PageViewController: UIPageViewController {
    
    weak var pageViewControllerDelegate: PageViewControllerDelegate?
    
    var viewControllerList = [FirstPageController]()
    
    let indicatorTitleLbl = ["推薦路線",
                             "組隊約騎",
                             "紀錄活動"]
    
    let indicatorImage = ["backView_guide_01",
                          "backView_guide_02",
                          "backView_guide_03"]
   
    let indicatorSubTitleLbl = ["提供台灣北中南東單車推薦路線",
                                "三五好友大家一起騎",
                                "紀錄騎乘距離、坡度、路線"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UIPageViewController 需要以下這兩項
        dataSource = self

        delegate = self
        
        appendViewControllerList(count: indicatorTitleLbl.count)

        self.setViewControllers([self.viewControllerList.first!],
                                direction: UIPageViewController.NavigationDirection.forward,
                                animated: true,
                                completion: nil)

        setIndicatorView()
    }
    
    private func appendViewControllerList(count: Int) {
        
        pageViewControllerDelegate?.pageViewController(self,
                                                       didUpdateNumberOfPage: count)
        
        for _ in 0..<count {
            
            viewControllerList
                .append(getViewController(withStoryboardID: FirstPageController.identifier))
        }
    }
    
    private func getViewController(withStoryboardID storyboardID: String) -> FirstPageController {
        
        let userIndicatorSB = StoryboardCategory.userIndicator.get
        
        let pageController = userIndicatorSB.instantiateViewController(
            identifier: storyboardID
            ) as! FirstPageController
        
        return pageController
    }
    
    private func setIndicatorView() {
        
        for number in 0..<viewControllerList.count {
            
            if number == 0 {
                
                viewControllerList[number].indicatorImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            
            viewControllerList[number].loadViewIfNeeded()
            
            viewControllerList[number].indicatorImage.image = UIImage(named: indicatorImage[number])
                        
            viewControllerList[number].indicatorTitleLbl.text = indicatorTitleLbl[number]
            
            viewControllerList[number].indicatorSubTitleLbl.text = indicatorSubTitleLbl[number]
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex: Int = viewControllerList.firstIndex(of: viewController as! FirstPageController)!
        
        let priviousIndex: Int = currentIndex - 1
        // 判斷上一頁的 index 是否小於 0，若小於 0 則停留在當前的頁數
        return priviousIndex < 0 ? nil : viewControllerList[priviousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex: Int = viewControllerList.firstIndex(of: viewController as! FirstPageController)!
        
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
        let currentIndex: Int = viewControllerList.firstIndex(of: currentViewController as! FirstPageController)!

        pageViewControllerDelegate?.pageViewController(self, didUpdatePageIndex: currentIndex)
    }
}
// swiftlint:ensable force_cast
