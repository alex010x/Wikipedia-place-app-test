//
//  MockFetchLocationUseCase.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import Foundation

final class MockFetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    var mockLocations: [Location] = []
    var shouldThrow: Bool = false
    
    func getLocations() async throws -> [Location] {
        if shouldThrow { throw URLError(.notConnectedToInternet) }
        return mockLocations
    }
}
