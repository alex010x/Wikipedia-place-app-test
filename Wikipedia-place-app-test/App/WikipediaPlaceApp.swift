//
//  Untitled.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import SwiftUI

struct WikipediaPlaceApp: App {
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
            deeplinkServiceHandler: dependencies.deeplinkHandler,
            errorHandler: dependencies.errorHandler
        )
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatedView(coordinator)
        }
    }
}
