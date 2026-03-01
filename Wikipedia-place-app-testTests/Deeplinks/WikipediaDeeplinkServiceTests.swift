//
//  WikipediaDeeplinkServiceTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest

@MainActor
final class WikipediaDeeplinkServiceTests: XCTestCase {
    
    private var mockURLOpener: MockURLOpener!
    private var sut: WikipediaDeeplinkService!
    private let testLocation = Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
    
    override func setUp() {
        super.setUp()
        mockURLOpener = MockURLOpener()
        sut = WikipediaDeeplinkService(urlOpener: mockURLOpener)
    }
    
    override func tearDown() {
        mockURLOpener = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - openWikipedia
    
    func testOpenWikipediaOpensCorrectScheme() async throws {
        // Given
        mockURLOpener.canOpenResult = true
        mockURLOpener.openResult = true
        
        // When
        try await sut.openWikipedia(for: testLocation)
        
        // Then
        XCTAssertEqual(mockURLOpener.openedURLs.first?.scheme, "wikipedia")
    }
    
    func testOpenWikipediaOpensCorrectHost() async throws {
        // Given
        mockURLOpener.canOpenResult = true
        mockURLOpener.openResult = true
        
        // When
        try await sut.openWikipedia(for: testLocation)
        
        // Then
        XCTAssertEqual(mockURLOpener.openedURLs.first?.host, "places")
    }
    
    func testOpenWikipediaUrlContainsCoordinatesQueryItem() async throws {
        // Given
        mockURLOpener.canOpenResult = true
        mockURLOpener.openResult = true
        
        // When
        try await sut.openWikipedia(for: testLocation)
        
        // Then
        let url = try XCTUnwrap(mockURLOpener.openedURLs.first)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItem = components?.queryItems?.first(where: { $0.name == "WMFPlacesCoordinates" })
        XCTAssertNotNil(queryItem)
    }
    
    func testOpenWikipediaThrowsCannotOpenURLWhenCannotOpen() async {
        // Given
        mockURLOpener.canOpenResult = false
        
        // When / Then
        do {
            try await sut.openWikipedia(for: testLocation)
            XCTFail("expected error to throw")
        } catch {
            XCTAssertEqual(error as? WikipediaDeeplinkService.DeeplinkError, .cannotOpenURL)
        }
    }
    
    func testOpenWikipediaThrowsCannotDeeplinkWhenOpenReturnsFalse() async {
        // Given
        mockURLOpener.openResult = false
        
        // When / Then
        do {
            try await sut.openWikipedia(for: testLocation)
            XCTFail("expected error to throw")
        } catch {
            XCTAssertEqual(error as? WikipediaDeeplinkService.DeeplinkError, .cannotDeeplink)
        }
    }
    
    func testOpenWikipediaOpensOnlyOneURL() async throws {
        // Given
        mockURLOpener.canOpenResult = true
        mockURLOpener.openResult = true
        
        // When
        try await sut.openWikipedia(for: testLocation)
        
        // Then
        XCTAssertEqual(mockURLOpener.openedURLs.count, 1)
    }
    
    // MARK: - Helpers
    private func makeExpectedURLSet() -> Set<URL> {
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        let coords = "{\"latitude\":41.9028,\"longitude\":12.4964}"
        components.queryItems = [URLQueryItem(name: "WMFPlacesCoordinates", value: coords)]
        return Set([components.url].compactMap { $0 })
    }
}
