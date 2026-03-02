//
//  NetworkService.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

/// Service is provided to repositories through injection
protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    let router: RouterProtocol
    
    required init(router: RouterProtocol) {
        self.router = router
    }
    
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T {
        try await router.request(endpoint: endpoint)
    }
}
