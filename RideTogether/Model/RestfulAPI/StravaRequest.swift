//
//  StravaRequest.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/17.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation

enum StravaRequest: Request {
        
    case getToken
    
    case getRouteData(token: String, routeID: String)
    
    var headers: [String: String] {
        
        switch self {
            
        case .getToken: return [HTTPHeaderField.contentType.rawValue: HTTPHeaderValue.json.rawValue]
            
        case .getRouteData(let token, _): return [HTTPHeaderField.auth.rawValue: "Bearer \(token)"]
        }
    }
    
    var body: Data? {
        
        switch self {
            
        case .getToken:

            let dict = ["client_id": 38371,
                        "client_secret": "b9e9b0bc892ae3c12d4c181df8930d17ff7bd8b2",
                        "grant_type": "refresh_token",
                        "refresh_token": "cfa09b3ce3ca214dfbd80509b3387b342b9c6e8a"] as [String : Any]
            
            return try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
        case .getRouteData: return nil
        }
    }
    
    var method: String {
        
        switch self {
            
        case .getToken: return HTTPMethod.POST.rawValue
            
        case .getRouteData: return HTTPMethod.GET.rawValue
        }
    }
    
    var endPoint: String {
        
        switch self {
            
        case .getToken: return "/oauth/token"
            
        case .getRouteData(_, let routeID): return "/api/v3/routes/\(routeID)"
        }
    }
}
