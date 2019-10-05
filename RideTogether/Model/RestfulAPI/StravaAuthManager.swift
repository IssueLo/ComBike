//
//  StravaAuthManager.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/18.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation

class StravaAuthManager {
    
    static func getToken(completion: @escaping (Result<Token>) -> Void) {
        
        let urlRequest = StravaRequest.getToken.makeRequest()
        
        // 提供 URL，得到回傳的 Data 取得 Token，再給出去
        HTTPClient.shared.tokenRequest(urlRequest) { (result) in
            
            switch result {
                
            case .success(let data):
                
                do {
                    
                    let decoder = JSONDecoder()
                    
                    let accessToken = try decoder.decode(Token.self, from: data)
                                        
                    completion(Result.success(accessToken))
                
                } catch {
                    
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                
                completion(Result.failure(error))
            }
        }
    }
}
