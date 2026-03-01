//
//  MockWikipediaDeeplinkService.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import Foundation

final class MockWikipediaDeeplinkService: WikipediaDeeplinkServiceProtocol {
    var shouldThrow = false
    var openedLocations: [Location] = []

    func openWikipedia(for location: Location) async throws {
        if shouldThrow { throw URLError(.badURL) }
        openedLocations.append(location)
    }
}
