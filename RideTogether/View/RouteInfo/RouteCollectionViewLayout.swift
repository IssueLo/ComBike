//
//  CollectionViewLayout.swift
//  WaterfallLayout
//
//  Created by 戴汝羽 on 2019/8/5.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import UIKit

protocol CollectionViewLayoutDelegate: AnyObject {
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForViewAtIndexPath indexPath: IndexPath) -> CGFloat
}

class CollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: CollectionViewLayoutDelegate?
    
    var numberOfColumns = 2  // 看要分成幾個 column
    var cellSpace: CGFloat = 8  // cell 之間間距
    
    var layoutAttributeCache = [UICollectionViewLayoutAttributes]()  // 建立一個 Array 儲存 ViewLayoutAttributes
    
    // 可滑動的 content 範圍
    var contentHeight: CGFloat = 0
    var contentWidth: CGFloat {
        
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset  // collectionView 到可視範圍的邊界條件
        return collectionView.bounds.width - (insets.left + insets.right)  // 寬度是
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // 覆寫 prepare() 功能，控制 Layout
    override func prepare() {
//        super.prepare()
        // 1 每次畫面滑動都會執行，需要 layoutAttributeCache.count == 0 來讓他停止
        guard layoutAttributeCache.count == 0,
            let collectionView = collectionView else { return }
        // 2 下一個 Cell 的原點 (x, y)
        let columnWidth = contentWidth / CGFloat(numberOfColumns)  // column 寬度
        
        print(" ")
        print("ScreenWidth: \(UIScreen.main.bounds.width)")
        print("CollectionViewContentWidth: \(contentWidth)")
        print("ColumnWidth: \(columnWidth)")
        print(" ")
        
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        // 3
        var currentColumn = 0
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            print("================================")
            print("Item: \(item)")
            
            let indexPath = IndexPath(item: item, section: 0)
            
            guard let delegate = delegate else {return}
            // 4 cell 高度跟位置是變數，view 高度需要 VC 透過 delegate 提供
            let viewHeight: CGFloat = delegate.collectionView(collectionView,
                                                              heightForViewAtIndexPath: indexPath)
            let cellHeight = cellSpace * 2 + viewHeight
            let frame = CGRect(x: xOffset[currentColumn],
                               y: yOffset[currentColumn],
                               width: columnWidth,
                               height: cellHeight)
            print("Frame: \(frame)")
            print(" ")
            // 把 Cell frame 屬性存放到 Array cache
            let insetFrame = frame.insetBy(dx: cellSpace, dy: cellSpace)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            layoutAttributeCache.append(attributes)
            // 計算 contentHeight
            print("currentContentHeight: \(contentHeight)")
            print("frame.maxY: \(frame.maxY)")
            
            contentHeight = max(contentHeight, frame.maxY)
            
            print("nextContentHeight: \(contentHeight)")
            print(" ")
            
            print("currentColumn: \(currentColumn)")
            
            print("[xOffset]: \(xOffset)")
            print("xOffset: \(xOffset[currentColumn])")
            
            yOffset[currentColumn] = yOffset[currentColumn] + cellHeight
            
            print("[yOffset]: \(yOffset)")
            print("yOffset: \(yOffset[currentColumn])")
            
            currentColumn = (currentColumn < (numberOfColumns - 1) ? (currentColumn + 1) : 0)
        }
        
        print("================================")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        //        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        //        for attributes in layoutAttributeCache {
        //            if attributes.frame.intersects(rect) {
        //                visibleLayoutAttributes.append(attributes)
        //            }
        //        }
        //
        //        print("visibleLayoutAttributes: \(visibleLayoutAttributes.count)")
        //
        //        return visibleLayoutAttributes
        //        print(layoutAttributeCache)
        //        print(layoutAttributeCache.count)
        return layoutAttributeCache
    }
    
    //     提供 Layout 訊息，UICollectionViewLayout 要求
    //    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //
    //        print(indexPath.item)
    //        return layoutAttributeCache[indexPath.item]
    //    }
}
