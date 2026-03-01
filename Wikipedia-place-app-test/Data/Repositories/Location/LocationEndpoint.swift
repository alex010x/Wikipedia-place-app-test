//
//  LocationEndpoint.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import Foundation

enum LocationEndpoint: APIEndpointProtocol {
    
    case pageLocation
    
    var path: String {
        switch self {
        case .pageLocation:
            return "/locations.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .pageLocation:
            return .get
        }
    }
    
    var parametersType: HTTPParametersType {
        return .json
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData
    }
    
    var timeoutInterval: TimeInterval? {
        return nil
    }
}
