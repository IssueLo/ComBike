//
//  UserIndicaterController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/25.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class UserIndicaterController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageVC = self.children[0] as? PageViewController
        
        pageVC?.pageViewControllerDelegate = self
    }
}

extension UserIndicaterController: PageViewControllerDelegate {

    func pageViewController(_ pageViewController: PageViewController, didUpdateNumberOfPage numberOfPage: Int) {

        pageControl.numberOfPages = numberOfPage
    }

    func pageViewController(_ pageViewController: PageViewController, didUpdatePageIndex pageIndex: Int) {

        pageControl.currentPage = pageIndex
    }
}
