//
//  Wikipedia_place_app_testApp.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import SwiftUI

@main
struct Wikipedia_place_app_testApp: App {
    var body: some Scene {
        WindowGroup {
            LocationView(viewModel: LocationViewModel(fetchLocationsUseCase: FetchLocationsUseCase(repository: LocationRepository(networkService: NetworkServiceFactory.createNetworkService()))))
        }
    }
}
