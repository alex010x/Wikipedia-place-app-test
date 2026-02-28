//
//  CustomLocationViewModel.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import Combine
import Foundation

@MainActor
final class CustomLocationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    @Published var showError: Bool = false
    
    private let useCase: AddCustomLocationUseCaseProtocol
    private let onAddNewLocation: () -> Void
    
    init(
        useCase: AddCustomLocationUseCaseProtocol,
        onAddNewLocation: @escaping () -> Void
    ) {
        self.useCase = useCase
        self.onAddNewLocation = onAddNewLocation
    }
    
    var isFormValid: Bool {
        parsedLatitude != nil && parsedLongitude != nil
    }
    
    var errorMessage: String {
        if parsedLatitude == nil {
            return "Latitude must be a number between -90 and 90."
        }
        if parsedLongitude == nil {
            return "Longitude must be a number between -180 and 180."
        }
        return ""
    }
    
    func onAddTapped() {
        guard let lat = parsedLatitude, let long = parsedLongitude else {
            showError = true
            return
        }
        
        Task {
            await useCase.addCustomLocation(
                name: name.isEmpty ? nil : name,
                latitude: lat,
                longitude: long
            )
            onAddNewLocation()
        }
    }
    
    // MARK: - Private
    
    private var parsedLatitude: Double? {
        guard let value = Double(latitude), (-90...90).contains(value) else { return nil }
        return value
    }
    
    private var parsedLongitude: Double? {
        guard let value = Double(longitude), (-180...180).contains(value) else { return nil }
        return value
    }
}

// MARK: Localized strings for View
extension CustomLocationViewModel {
    var placeholderForNameText: String { "Name (optional)" }
    var navigationTitle: String { "Add new location" }
    var locationNameHeaderText: String { "Location name" }
    var cancelButtonText: String { "Cancel" }
    var latitudeFieldPlaceholderText: String { "e.g. 41.9028" }
    var longitudeFieldPlaceholderText: String { "e.g. 12.4964" }
    var coordinatesHeaderText: String { "Coordinates" }
    var coordinatesFooterText: String { "Latitude must be between -90 and 90. Longitude between -180 and 180." }
    var addNewLocationText: String { "Add" }
    var doneText: String { "Done" }
    var invalidCoordinatesErrorText: String { "Invalid coordinates" }
    var okButtonText: String { "Ok" }
}

// MARK: Accessibility
extension CustomLocationViewModel {
    var accessibilityLatitudeText: String { "Latitude" }
    var accessibilityLatitudeHint: String { "Insert here the latitude of the location" }
    var accessibilityLongitudeText: String { "Longitude" }
    var accessibilityLongitudeHint: String { "Insert here the longitude of the location" }
    var accessibilityNameText: String { "Name of the location" }
    var accessibilityNameHint: String { "Insert here the name of the location" }
    var alertAnnouncementErrorText: String { "Error, please form correctly the coordinates" }
}
