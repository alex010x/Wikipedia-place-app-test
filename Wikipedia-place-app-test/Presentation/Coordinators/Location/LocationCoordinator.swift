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
    @StateObject private var viewModel: LocationViewModel
    
    private let fetchLocationUseCase: FetchLocationsUseCaseProtocol
    private let addCustomLocationUseCase: AddCustomLocationUseCaseProtocol
    private let deeplinkServiceHandler: WikipediaDeeplinkServiceProtocol
    @ObservedObject private var errorHandler: ErrorHandler
    
    init(
        fetchLocationUseCase: FetchLocationsUseCaseProtocol,
        addCustomLocationUseCase: AddCustomLocationUseCaseProtocol,
        deeplinkServiceHandler: WikipediaDeeplinkServiceProtocol,
        errorHandler: ErrorHandler
    ) {
        self.fetchLocationUseCase = fetchLocationUseCase
        self.addCustomLocationUseCase = addCustomLocationUseCase
        self.deeplinkServiceHandler = deeplinkServiceHandler
        self.errorHandler = errorHandler
        self._viewModel = StateObject(wrappedValue: LocationViewModel(fetchLocationsUseCase: fetchLocationUseCase))
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            locationView
        }
    }
    
    private var locationView: some View {
        LocationView(
            viewModel: viewModel,
            onLocationTap: { location in
                Task {
                    do {
                        try await deeplinkServiceHandler.openWikipedia(for: location)
                    } catch {
                        errorHandler.handle(error)
                    }
                }
            }
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
            CustomLocationView(viewModel: CustomLocationViewModel(
                useCase: addCustomLocationUseCase,
                onAddNewLocation: {
                    Task {
                        await viewModel.fetchLocations()
                    }
                }
            ))
        }
        .errorAlert(handler: errorHandler)
    }
}

// MARK: Accessibility
private enum AccessibilityCoordinatorValues: String {
    case addNewLocationLabel = "Add new custom location"
    case addNewLocationHint = "Tap here to add a new location to the list"
}

// MARK: - Localized strings
private enum CoordinatorViewLocalizedConstants: String {
    case okButtonTitle = "Ok"
    case errorTextTitle = "Error"
}
