//
//  RouteManager.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/10/3.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation

class RouteInfoManager {
    
    static func getRouteInfo(routeIDList: [[String]] ,
                             handler: @escaping ([[RouteData]]) -> Void) {
        
        var allRouteData = [[RouteData]]()
        
        let group = DispatchGroup()
        // 這要搬去 Model?
        for area in routeIDList {
            
            var currentRouteData = [RouteData]()
            
            for routeID in area {
                
                group.enter()
                
                StravaProvider.getRouteData(routeID) { (result) in
                    
                    switch result {
                        
                    case .success(var routeData):
                        
                        let array = routeData.name.components(separatedBy: "：")
                        
                        if array.count == 1 {
                            
                            routeData.name = array[0]
                        } else {
                            
                            routeData.name = array[1]
                        }
                        
                        currentRouteData.append(routeData)
                        
                        group.leave()
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            
            group.notify(queue: .main, execute: {
                
                allRouteData.append(currentRouteData)
                
                handler(allRouteData)
            })
        }
    }
}
