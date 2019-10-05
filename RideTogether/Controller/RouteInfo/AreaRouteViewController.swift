//
//  AreaRouteViewController.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/22.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

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
            
            areaRouteCollectionView.registerCell(nibName: AreaRouteCell.identifier)
            
            let cellSpace: CGFloat = 8
            
            areaRouteCollectionView.contentInset = UIEdgeInsets(top: cellSpace,
                                                                left: cellSpace,
                                                                bottom: cellSpace,
                                                                right: cellSpace)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for Waterfall Layout
        if let layout = areaRouteCollectionView.collectionViewLayout as? CollectionViewLayout {
            
            layout.delegate = self
        }
    }
}

extension AreaRouteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return areaRouteData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AreaRouteCell.identifier,
                                                      for: indexPath)
        
        guard let areaRouteCell = cell as? AreaRouteCell else { return cell }
        
        let routeNameArray = areaRouteData[indexPath.row].name.components(separatedBy: "（")
        
        areaRouteCell.routeNameLabel.text = routeNameArray[0]
        
        let urlString = "https://bike100.tw/wp-content/uploads/\(areaRouteData[indexPath.row].routeID).jpg"
        
        areaRouteCell.routeView.setImage(urlString: urlString)
        
        return areaRouteCell
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = StoryboardCategory.routeDetail.getStoryboard()
                    
        guard
            let routeDetailVC = storyboard.instantiateViewController(
                withIdentifier: RouteDetailViewController.identifier
                ) as? RouteDetailViewController
            
        else { return }
        
        routeDetailVC.routeData = self.areaRouteData[indexPath.row]
        
        routeDetailVC.hidesBottomBarWhenPushed = true
        
        self.show(routeDetailVC, sender: nil)
    }
}

extension AreaRouteViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
}

extension AreaRouteViewController: CollectionViewLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForViewAtIndexPath indexPath: IndexPath) -> CGFloat {

        let number = indexPath.item % 4

        switch number {
        case 0: return 260
        case 1: return 220
        case 2: return 180
        case 3: return 300
        default:
            return 100
        }
    }
}

//extension AreaRouteViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let screenWidth = UIScreen.main.bounds.width
//
//        let width = (screenWidth - 28) / 2
//
//        let height = width * 140 / 170
//
//        return CGSize(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 24, left: 14, bottom: 24, right: 14)
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//
//        return 0
//    }
//}
