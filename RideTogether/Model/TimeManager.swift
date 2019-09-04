//
//  Timer.swift
//  StravaAPITest
//
//  Created by 戴汝羽 on 2019/8/28.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

//import Foundation
import UIKit

class TimerManager {
    
    static var shared = TimerManager()
    
    private init() {}
    
    var timerMove: Timer?
    
    var currentSecond = 0
    
    var timeIsStop = true
    
    func timeMove(repeats: Bool, runtime: TimeInterval, label: UILabel) {
        
        timerMove = Timer.scheduledTimer(withTimeInterval: runtime, repeats: repeats, block: { (_) in
            
            self.currentSecond += 1
            
            let secInt = self.currentSecond % 60

            let minsInt = (self.currentSecond / 60) % 60

            let hourInt = (self.currentSecond / 3600) % 24
            
            let sec = String(format: "%02d", secInt)
            
            let mins = String(format: "%02d", minsInt)
            
            let hour = String(format: "%02d", hourInt)

            label.text = "\(hour)：\(mins)：\(sec)"
        })
    }
    
    func controlButton(_ label: UILabel) {
        
        if timeIsStop {
            
            timeMove(repeats: true, runtime: 0.1, label: label)
            
            timeIsStop = !timeIsStop
        } else {
            
            timerMove?.invalidate()
            
            timeIsStop = !timeIsStop
        }
    }
}
