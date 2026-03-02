//
//  LocationViewModel.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import Foundation
import Combine

@MainActor
final class LocationViewModel: ObservableObject {
    
    // MARK: - View State
    enum LocationState {
        case loading, loaded, error(Error)
    }
    
    // MARK: - Properties
    
    @Published private(set) var locations = [Location]()
    @Published private(set) var state: LocationState = .loading
    
    private let fetchLocationsUseCase: FetchLocationsUseCaseProtocol
    
    // MARK: - Init
    init(
        fetchLocationsUseCase: FetchLocationsUseCaseProtocol
    ) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
    }
    
    func fetchLocations() async {
        do {
            locations = try await fetchLocationsUseCase.getLocations()
            state = .loaded
        } catch {
            state = .error(error)
        }
    }
}

// MARK: - Accessibility

extension LocationViewModel {
    func getAccessibilityLabel(for location: Location) -> String {
        """
        Location: \(location.viewName), latitude: \(location.latitude), longitude: \(location.longitude)
        """
    }
    
    func getAccessibilityHint(for location: Location) -> String {
        if let name = location.name {
            return "Tap to get redirected on the Wikipedia app and see \(name) there."
        } else {
            return "Tap to get redirected on the Wikipedia app and see this location with latitude \(location.latitude) and longitude \(location.longitude) there."
        }
    }
    
    var accessibilityRequestFailureAnnouncement: String {
        "There was an error with your request. Please tap on retry."
    }
    
    var accessibilityLoadingLocations: String {
        "Loading locations"
    }
}

// MARK: Localized strings for View
extension LocationViewModel {
    var retryButtonText: String {
        "Retry"
    }
}
