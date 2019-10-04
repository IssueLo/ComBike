//
//  DateManager.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/4.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation

class DateManager {
    
    static func secondToDate(seconds: Int) -> String {
        
        // 轉換為時間
        let timeInterval: TimeInterval = TimeInterval(seconds)
        
        let date = Date(timeIntervalSince1970: timeInterval)

        // 輸出格式設定
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "yyyy年MM月dd日"
        
        return dateformatter.string(from: date)
    }
    
}
