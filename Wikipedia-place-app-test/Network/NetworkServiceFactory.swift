//
//  NetworkServiceFactory.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

struct NetworkServiceFactory {
    
    static func createNetworkService() -> NetworkService {
        let networkRouter = NetworkRouter(
            session: URLSession.shared,
            configuration: .default
        )
        let networkManager = NetworkManager(router: networkRouter)
        return NetworkService(networkManager: networkManager)
    }
}
