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
        
        //转换为时间
        let timeInterval: TimeInterval = TimeInterval(seconds)
        let date = Date(timeIntervalSince1970: timeInterval)

        //格式话输出
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy年MM月dd日"
        return dateformatter.string(from: date)
    }
    
}
