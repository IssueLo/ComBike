//
//  Timer.swift
//  StravaAPITest
//
//  Created by 戴汝羽 on 2019/8/28.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

//import Foundation
import UIKit

class TimeManager {
    
//    static var shared = TimeManager()
//    
//    private init() {}
    
    var timerMove: Timer?
    
    var currentSecond = 0
    
    var timeIsStop = true
    
    func timeMove(repeats: Bool, runtime: TimeInterval, label: UILabel) {
        
        timerMove = Timer.scheduledTimer(withTimeInterval: runtime, repeats: repeats, block: { (_) in
            
            self.currentSecond += 1
            
            label.text = self.secToRealTime(self.currentSecond)
        })
    }
    
    func controlButton(_ label: UILabel) {
        
        if timeIsStop {
            
            timeMove(repeats: true, runtime: 1, label: label)
            
            timeIsStop = !timeIsStop
        } else {
            
            timerMove?.invalidate()
            
            timeIsStop = !timeIsStop
        }
    }
    
    func secToRealTime (_ sec: Int) -> String {
        
        let secInt = sec % 60
        
        let minsInt = (sec / 60) % 60
        
        let hourInt = (sec / 3600) % 24
        
        let sec = String(format: "%02d", secInt)
        
        let mins = String(format: "%02d", minsInt)
        
        let hour = String(format: "%02d", hourInt)
        
        return "\(hour):\(mins):\(sec)"
    }
}
