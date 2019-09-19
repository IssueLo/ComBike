//
//  RouteListCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/18.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RouteListCell: UITableViewCell {
    
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
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "RouteCell", bundle: nil)
        
        routeCollectionView.register(nib, forCellWithReuseIdentifier: "RouteCell")
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
        
        routeCell.routeNameLabel.text = routeListData[indexPath.row].name
        
        let urlString = "https://bike100.tw/wp-content/uploads/\(routeListData[indexPath.row].routeID).jpg"
        
        routeCell.routeView.setImage(urlString: urlString)
        
        return routeCell
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

        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 12, bottom: 24, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
}
