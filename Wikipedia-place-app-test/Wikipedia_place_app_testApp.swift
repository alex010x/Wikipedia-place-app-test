//
//  Wikipedia_place_app_testApp.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import SwiftUI

@main
struct Wikipedia_place_app_testApp: App {
    
    private let coordinator: LocationCoordinator
    
    init() {
        let repository = LocationRepository(
            networkService: NetworkServiceFactory.createNetworkService(),
            customLocationCache: CustomCache()
        )
        coordinator = LocationCoordinator(
            fetchLocationUseCase: FetchLocationsUseCase(repository: repository),
            addCustomLocationUseCase: AddCustomLocationUseCase(repository: repository)
        )
    }
    
    var body: some Scene {
        WindowGroup {
            coordinator
        }
    }
}
