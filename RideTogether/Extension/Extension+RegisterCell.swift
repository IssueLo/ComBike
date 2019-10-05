//
//  Extension+RegisterCell.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerCell(nibName: String) {
        
        let nib = UINib(nibName: nibName, bundle: nil)

        register(nib, forCellReuseIdentifier: nibName)
    }
    
    func registerHeader(nibName: String) {
        
        let nib = UINib(nibName: nibName, bundle: nil)

        register(nib, forHeaderFooterViewReuseIdentifier: nibName)
    }
}

extension UICollectionView {
    
    func registerCell(nibName: String) {
        
        let nib = UINib(nibName: nibName, bundle: nil)

        register(nib, forCellWithReuseIdentifier: nibName)
    }
}
