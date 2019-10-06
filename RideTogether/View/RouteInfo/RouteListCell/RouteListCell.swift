//
//  RouteListCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/18.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RouteListCell: UITableViewCell {
    
    var handler: ((IndexPath) -> Void)?
    
    var routeListData = [RouteData]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.routeCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var routeCollectionView: UICollectionView! {
        
        didSet {
            
            routeCollectionView.dataSource = self
            
            routeCollectionView.delegate = self
            
            routeCollectionView.registerCell(nibName: RouteCell.identifier)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension RouteListCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return routeListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RouteCell", for: indexPath)
        
        guard let routeCell = cell as? RouteCell else { return cell }
        
        let routeNameArray = routeListData[indexPath.row].name.components(separatedBy: "（")
        
        routeCell.routeNameLabel.text = routeNameArray[0]
        
        let urlString = "https://bike100.tw/wp-content/uploads/\(routeListData[indexPath.row].routeID).jpg"
        
        routeCell.routeView.setImage(urlString: urlString)
        
        return routeCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
//        let storyboard = UIStoryboard(name: "DetailRouteStoryboard", bundle: nil)
//
//        guard
//            let routeDetailVC = storyboard.instantiateViewController(withIdentifier: "DetailRouteStoryboard")
//                as? RouteDetailViewController
//        else { return }
//
//        routeDetailVC.routeData = self.routeListData[indexPath.row]
        
        handler!(indexPath)
    }
}

extension RouteListCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0

        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {

            cell.alpha = 1
        })

        animator.startAnimation()
    }
}

extension RouteListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 142, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
}
