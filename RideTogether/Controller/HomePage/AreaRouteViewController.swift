//
//  AreaRouteViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/22.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit
import Crashlytics

class AreaRouteViewController: UIViewController {
        
    var areaRouteData = [RouteData]() {
        
        didSet {
            
            DispatchQueue.main.async {

                self.areaRouteCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var areaRouteCollectionView: UICollectionView! {
        
        didSet {
            
            areaRouteCollectionView.dataSource = self
            
            areaRouteCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Crashlytics.sharedInstance().crash()

        let nib = UINib(nibName: "RouteCell", bundle: nil)
        
        areaRouteCollectionView.register(nib, forCellWithReuseIdentifier: "RouteCell")
    }
}

extension AreaRouteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return areaRouteData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteCell", for: indexPath)
        
        guard let routeCell = cell as? RouteCell else { return cell }
        
        let routeNameArray = areaRouteData[indexPath.row].name.components(separatedBy: "（")
        
        routeCell.routeNameLabel.text = routeNameArray[0]
        
        let urlString = "https://bike100.tw/wp-content/uploads/\(areaRouteData[indexPath.row].routeID).jpg"
        
        routeCell.routeView.setImage(urlString: urlString)
        
        return routeCell
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "RouteDetailStoryboard", bundle: nil)

        guard
            let routeDetailVC = storyboard.instantiateViewController(withIdentifier: "RouteDetailStoryboard")
                as? RouteDetailViewController
        else { return }
        
        routeDetailVC.routeData = self.areaRouteData[indexPath.row]
        
        routeDetailVC.hidesBottomBarWhenPushed = true
        
        self.show(routeDetailVC, sender: nil)
    }
    
}

extension AreaRouteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width
        
        let width = (screenWidth - 28) / 2
        
        let height = width * 140 / 170
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 24, left: 14, bottom: 24, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
