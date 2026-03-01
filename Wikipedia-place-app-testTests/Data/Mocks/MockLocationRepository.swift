//
//  MockLocationRepository.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import Foundation

final class MockLocationRepository: LocationRepositoryProtocol {
    var mockLocations: [Location] = []
    var shouldThrow: Bool = false
    
    func fetchAll() async throws -> [Location] {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return mockLocations
    }
    
    func addCustomLocation(_ location: Location) async {
        mockLocations.append(location)
    }
}
