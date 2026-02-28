//
//  APIEndpointProtocol.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

enum HTTPParametersType {
    case urlEncoded
    case json
}

/// EndpointProtocol
protocol APIEndpointProtocol {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension APIEndpointProtocol {
    func createURLRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + APIPrefix.main.rawValue + path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        
        // Append query items and/or raw query string
        if let requestURL = request.url,
           var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) {
            
            if let additionalQueryItems = queryItems, !additionalQueryItems.isEmpty {
                components.queryItems = (components.queryItems ?? []) + additionalQueryItems
            }
            
            request.url = components.url
        }
        
        // Set HTTP Method
        request.httpMethod = method.rawValue
        
        // Set Cache Policy
        request.cachePolicy = cachePolicy
        
        return request
    }
    
}
