//
//  RouterProtocol.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

/// Routing interface
protocol RouterProtocol {
    var session: URLSessionDataProtocol { get }
    var configuration: NetworkServiceConfiguration { get }
    
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T
}

protocol URLSessionDataProtocol {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
}

extension URLSessionDataProtocol {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)? = nil
    ) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: delegate)
    }
}

extension URLSession: URLSessionDataProtocol {}
