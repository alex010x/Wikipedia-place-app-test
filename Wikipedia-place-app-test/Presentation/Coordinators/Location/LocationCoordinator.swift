//
//  LocationCoordinator.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import SwiftUI

struct LocationCoordinator: View {
    @State private var isAddingLocation = false
    @State private var navigationPath = NavigationPath()

    private let fetchLocationUseCase: FetchLocationsUseCaseProtocol
    private let addCustomLocationUseCase: AddCustomLocationUseCaseProtocol
    
    init(
        fetchLocationUseCase: FetchLocationsUseCaseProtocol,
        addCustomLocationUseCase: AddCustomLocationUseCaseProtocol
    ) {
        self.fetchLocationUseCase = fetchLocationUseCase
        self.addCustomLocationUseCase = addCustomLocationUseCase
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            locationView
        }
    }
    
    private var locationView: some View {
        LocationView(
            viewModel: LocationViewModel(
                fetchLocationsUseCase: fetchLocationUseCase
            )
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isAddingLocation = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(AccessibilityCoordinatorValues.addNewLocationLabel.rawValue)
                .accessibilityAddTraits(.isButton)
                .accessibilityHint(AccessibilityCoordinatorValues.addNewLocationHint.rawValue)
            }
        }
        .sheet(isPresented: $isAddingLocation) {
            CustomLocationView(viewModel: CustomLocationViewModel(useCase: addCustomLocationUseCase))
        }
    }
}

// MARK: Location destination

enum LocationDestination: Destination {
    case locationView
    
    var id: String {
        switch self {
        case .locationView:
            return "location_view"
        }
    }
}

private enum AccessibilityCoordinatorValues: String {
    case addNewLocationLabel = "Add new custom location"
    case addNewLocationHint = "Tap here to add a new location to the list"
}
