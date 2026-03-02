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
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension APIEndpointProtocol {
    func createURLRequest(baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL + APIPrefix.main.rawValue + path) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        
        // Normalizes the URL through URLComponents to ensure proper percent-encoding
        // and query string formatting before sending the request
        if let requestURL = request.url,
           let components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) {
            request.url = components.url
        }
        
        request.httpMethod = method.rawValue
        request.cachePolicy = cachePolicy
        
        return request
    }
}
