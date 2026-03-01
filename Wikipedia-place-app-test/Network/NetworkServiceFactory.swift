//
//  NetworkServiceFactory.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

struct NetworkServiceFactory {
    
    private init() {
        // No-op - no init as factory.
    }
    
    static func createNetworkService() -> NetworkService {
        let networkRouter = NetworkRouter(
            session: URLSession.shared,
            configuration: .default
        )
        return NetworkService(router: networkRouter)
    }
}
