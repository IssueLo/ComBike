//
//  GroupSortingManager.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation
import FirebaseFirestore

class GroupSortingManager {
    
    static func sortingByDate(groupData: [GroupData]) -> [GroupData] {
        
        var sortedGroupData: [GroupData] = [groupData[0]]
        
        for numberInAll in 1..<groupData.count {
            
            for numberInSorted in sortedGroupData.indices {
                
                if groupData[numberInAll].createTime.seconds > sortedGroupData[numberInSorted].createTime.seconds {
                    
                    sortedGroupData.insert(groupData[numberInAll], at: numberInSorted)
                    
                    break
                    
                } else {
                    
                    if numberInSorted == sortedGroupData.count - 1 {
                        
                        sortedGroupData.insert(groupData[numberInAll], at: numberInSorted)
                        
                        break
                    }
                }
            }
        }
                
        return sortedGroupData
    }
    
    static func separatedGroupData(sortedGroupData: [GroupData]) -> [[GroupData]] {
        
        if sortedGroupData.count == 0 {
            
            return []
        }
        
        var dateTitles: [String] = [DateManager.secondToDate(seconds: Int(sortedGroupData[0].createTime.seconds))]
        
        var separatedGroupData: [[GroupData]] = [[sortedGroupData[0]]]
        
        for numberInSorted in 1..<sortedGroupData.count {
            
            let seconds = Int(sortedGroupData[numberInSorted].createTime.seconds)
            
            let date = DateManager.secondToDate(seconds: seconds)
            
            if date == dateTitles.last {
                
                separatedGroupData[dateTitles.count - 1].append(sortedGroupData[numberInSorted])
                
            } else {
                
                dateTitles.append(date)
                
                separatedGroupData.append([sortedGroupData[numberInSorted]])
            }
        }
        
        return separatedGroupData
    }
}
