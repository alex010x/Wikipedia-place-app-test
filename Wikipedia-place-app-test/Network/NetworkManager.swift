//
//  NetworkManager.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

/// Manager allows performing a request through the injected router
protocol NetworkManagerProtocol {
    var router: RouterProtocol { get }
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    
    let router: RouterProtocol
    
    required init(router: RouterProtocol) {
        self.router = router
    }
    
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T {
        try await router.request(endpoint: endpoint)
    }
}
