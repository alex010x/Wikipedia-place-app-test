//
//  AppDependencies.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

struct AppDependencies {
    let networkService: NetworkServiceProtocol
    let cache: CustomLocationCacheProtocol
    let deeplinkHandler: WikipediaDeeplinkServiceProtocol
    
    static func makeDefault() -> AppDependencies {
        AppDependencies(
            networkService: NetworkServiceFactory.createNetworkService(),
            cache: CustomLocationCache(),
            deeplinkHandler: WikipediaDeeplinkService(urlOpener: URLOpener())
        )
    }
}
