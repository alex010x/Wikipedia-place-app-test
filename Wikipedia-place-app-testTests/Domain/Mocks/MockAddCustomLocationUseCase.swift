//
//  MockAddCustomLocationUseCase.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import Foundation

final class MockAddCustomLocationUseCase: AddCustomLocationUseCaseProtocol {
    var mockLocations: [Location] = []
    var shouldThrow: Bool = false
    
    func addCustomLocation(name: String?,
                           latitude: Double,
                           longitude: Double) async {
        mockLocations.append(
            Location(name: name,
                     latitude: latitude,
                     longitude: longitude)
        )
    }
}
