//
//  HTTPClient.swift
//  RideTogether
//
//  Created by 戴汝羽 on 2019/9/14.
//  Copyright © 2019 KevinKLLo. All rights reserved.
//

import Foundation
import Alamofire

enum Result<T> {
    
    case success(T)
    
    case failure(Error)
}

enum HTTPClientError: Error {
    
    case authorizationError
    
    case decodeDataFail
    
    case clientError(Data)
    
    case serverError
    
    case unexpectedError
}

enum HTTPMethod: String {
    
    case GET
    
    case POST
}

enum HTTPHeaderField: String {
    
    case contentType = "Content-Type"
    
    case auth = "Authorization"
}

enum HTTPHeaderValue: String {
    
    case json = "application/json"
}

protocol Request {
    
    var headers: [String: String] { get }
    
    var body: Data? { get }
    
    var method: String { get }
    
    var endPoint: String { get }
}

extension Request {
    
    func makeRequest() -> URLRequest {
        
        let urlString = "https://www.strava.com" + endPoint
        
        let url = URL(string: urlString)!
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.allHTTPHeaderFields = headers
        
        urlRequest.httpMethod = method
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private let decoder = JSONDecoder()
    
    private let encoder = JSONEncoder()
    
    private init() { }
    
    func request(_ url: URLRequest,
                 _ completion: @escaping (Result<RouteData>) -> Void) {
        
        Alamofire.request(url).responseJSON { (response) in
            
            //            print(response.request)  // 原始的 URL 要求
            //            print(response.response?.statusCode) // URL 回應
            //            print(response.data)     // 伺服器資料
            //            print(response.result)   // 回應的序列化結果
            
            //            if let JSON = response.result.value {
            //
            //                print(JSON)
            //
            //            }
            
            guard let data = response.data else { return }
            
            do {
                
                let decoder = JSONDecoder()
                
                let dataObject = try decoder.decode(RouteData.self, from: data)
                
                completion(Result.success(dataObject))
                
            } catch {
                
                completion(Result.failure(error))
            }
        }
    }
    
    // 拿到 TokenURL，解開 Data 回傳回去
    func tokenRequest(_ url: URLRequest,
                      completion: @escaping (Result<Data>) -> Void) {
        
        Alamofire.request(url).responseJSON { (response) in
            
//            print(response.response) // URL 回應
//            print(response.data)     // 伺服器資料
//            print(response.result)   // 回應的序列化結果
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
                
            case 200..<300:
                
                completion(Result.success(response.data!))
                
            case 400..<500:
                
                completion(Result.failure(HTTPClientError.clientError(response.data!)))
                
            case 500..<600:
                
                completion(Result.failure(HTTPClientError.serverError))
                
            default: return
                
                completion(Result.failure(HTTPClientError.unexpectedError))

            }
            
            guard let data = response.data else { return }
            
            do {
                
                let decoder = JSONDecoder()
                
                let dataObject = try decoder.decode(Token.self, from: data)
                
                print(dataObject)
                
            } catch {
                
            }
        }
    }
}

struct RouteData: Codable {
    
    let routeID: Int
    
    var name: String
    
    let distance: Double
    
    let map: Map
    
    let estimatedTime: Int
    
    let elevationGain: Double
    
    enum CodingKeys: String, CodingKey {
        
        case name, distance, map
        
        case routeID = "id"
        
        case estimatedTime = "estimated_moving_time"
        
        case elevationGain = "elevation_gain"
        
    }
}

struct Map: Codable {
    
    let polyline: String
    
    enum CodingKeys: String, CodingKey {
        
        case polyline = "summary_polyline"
    }
}

struct Token: Codable {
    
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        
        case accessToken = "access_token"
    }
}
