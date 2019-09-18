//
//  RouteListCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/18.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

class RouteListCell: UITableViewCell {
    
    var routeListData = [String]()
    
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
        
        routeCell.routeNameLabel.text = routeListData[indexPath.row]
        
        return routeCell
    }
}

extension RouteListCell: UICollectionViewDelegate {
    
}

extension RouteListCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 140, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
}
