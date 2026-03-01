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
        let dependencies = AppDependencies.makeDefault()
        
        let repository = LocationRepository(
            networkService: dependencies.networkService,
            customLocationCache: dependencies.cache,
        )
        
        coordinator = LocationCoordinator(
            fetchLocationUseCase: FetchLocationsUseCase(repository: repository),
            addCustomLocationUseCase: AddCustomLocationUseCase(repository: repository),
            deeplinkServiceHandler: dependencies.deeplinkHandler
        )
    }
    
    var body: some Scene {
        WindowGroup {
            coordinator
        }
    }
}
