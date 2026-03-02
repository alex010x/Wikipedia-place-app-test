//
//  LocationEndpointTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest

final class LocationEndpointTests: XCTestCase {
    
    @MainActor
    func testDefaultValuesForLocationEndpoint() {
        // Given
        let endpoint = LocationEndpoint.pageLocation
        
        // Then
        let expectedPath = "/locations.json"
        
        // Then
        XCTAssertEqual(endpoint.path, expectedPath)
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.parametersType, .json)
        XCTAssertNil(endpoint.parameters)
        XCTAssertNil(endpoint.headers)
        XCTAssertNil(endpoint.queryItems)
        XCTAssertEqual(endpoint.cachePolicy, .reloadIgnoringLocalCacheData)
        XCTAssertNil(endpoint.timeoutInterval)
    }
}
