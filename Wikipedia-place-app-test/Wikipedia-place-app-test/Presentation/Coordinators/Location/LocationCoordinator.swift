// MARK: - LocationCoordinator.swift

import SwiftUI
import Combine

final class LocationCoordinator: Coordinator {
    typealias Route = Never // no navigation from here

    let navigationController = NavigationController() // first coordinator on the stack
    @Published var sheet: LocationCoordinatorSheet?
    
    private let fetchLocationUseCase: FetchLocationsUseCaseProtocol
    private let addCustomLocationUseCase: AddCustomLocationUseCaseProtocol
    private let deeplinkServiceHandler: WikipediaDeeplinkServiceProtocol
    private let errorHandler: ErrorHandler
    private let viewModel: LocationViewModel
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
        self.viewModel = LocationViewModel(fetchLocationsUseCase: fetchLocationUseCase)
    }

    @ViewBuilder
    var rootView: some View {
        LocationView(
            viewModel: viewModel,
            onLocationTap: { [weak self] location in
                self?.handleLocationTap(location)
            }
        )
        .navigationDestination(for: Route.self, destination: coordinate(_:))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.showAddCustomLocation()
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(AccessibilityValues.addNewLocationLabel)
                .accessibilityAddTraits(.isButton)
                .accessibilityHint(AccessibilityValues.addNewLocationHint)
            }
        }
        .sheet(item: Binding(
            get: { self.sheet },
            set: { self.sheet = $0 }
        )) { sheet in
            self.buildSheet(
                sheet: sheet,
                onAddNewLocation: { [weak self] in
                    await self?.viewModel.fetchLocations()
                }
            )
        }
        .errorAlert(handler: errorHandler)
    }
}

// MARK: - LocationCoordinatorProtocol

extension LocationCoordinator: LocationCoordinatorProtocol {

    func showAddCustomLocation() {
        sheet = .addCustomLocation
    }

    func dismissSheet() {
        sheet = nil
    }

    func handleLocationTap(_ location: Location) {
        Task {
            do {
                try await deeplinkServiceHandler.openWikipedia(for: location)
            } catch {
                errorHandler.handle(error)
            }
        }
    }
}

// MARK: - Sheet Builder

private extension LocationCoordinator {

    @ViewBuilder
    func buildSheet(
        sheet: LocationCoordinatorSheet,
        onAddNewLocation: @escaping () async -> Void
    ) -> some View {
        switch sheet {
        case .addCustomLocation:
            CustomLocationView(
                viewModel: CustomLocationViewModel(
                    useCase: addCustomLocationUseCase,
                    onAddNewLocation: {
                        Task { await onAddNewLocation() }
                    }
                )
            )
        }
    }
}

// MARK: - Accessibility

private enum AccessibilityValues {
    static let addNewLocationLabel = "Add new custom location"
    static let addNewLocationHint = "Tap here to add a new location to the list"
}
