//
//  StravaProvider.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/18.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation

class StravaProvider {
    
    static func getRouteData(_ routeID: String,
                             completion: @escaping (Result<RouteData>) -> Void) {
        
        StravaAuthManager.getToken { (result) in
            
            switch result {
                
            case .success(let token):
                
                let url = StravaRequest.getRouteData(token: token.accessToken, routeID: routeID).makeRequest()
                                
                HTTPClient.shared.request(url, completion)
                
            case .failure:
                                
                return
            }
        }
    }
}
