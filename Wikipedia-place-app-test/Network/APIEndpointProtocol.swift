//
//  APIEndpointProtocol.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

/// Represents the encoding strategy used when attaching parameters to an HTTP request.
///
/// Use this type to indicate how request parameters should be serialized and transmitted:
/// - `.urlEncoded`: Parameters are percent-encoded and appended to the URL as a query string
///   (commonly used with GET requests) or encoded into the HTTP body using the
///   `application/x-www-form-urlencoded` content type.
/// - `.json`: Parameters are serialized as JSON and placed in the HTTP body using the
///   `application/json` content type (commonly used with POST/PUT/PATCH requests).
///
/// Choosing the correct parameter type ensures compatibility with the target API and
/// influences how the request is constructed and how servers interpret the payload.
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

/// Creates and returns a configured URLRequest for the endpoint using the provided base URL.
///
/// This method constructs the full URL by concatenating the given baseURL, a predefined API prefix,
/// and the endpoint’s path. It then attaches any specified query items, sets the HTTP method,
/// and applies the desired cache policy.
///
/// - Parameter baseURL: The base URL string for the API (e.g., "https://example.com") to which the API prefix and path are appended.
/// - Returns: A URLRequest configured with the endpoint’s URL, HTTP method, and cache policy.
/// - Throws: `NetworkError.invalidURL` if the composed URL is invalid or cannot be created.
///
/// Behavior:
/// - Builds a URL as: baseURL + APIPrefix.main.rawValue + path.
/// - Merges existing URL query items (if any) with `queryItems` provided by the endpoint.
/// - Sets `httpMethod` to the endpoint’s `method`.
/// - Sets `cachePolicy` to the endpoint’s `cachePolicy`.
///
/// Use this method inside network layers to obtain a ready-to-send request for the conforming endpoint.
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
