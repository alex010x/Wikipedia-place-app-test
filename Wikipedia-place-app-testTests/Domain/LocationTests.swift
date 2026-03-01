//
//  LocationTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest

final class LocationTests: XCTestCase {
    
    func testViewNameMappedCorrectlyFromName() {
        let location = Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        XCTAssertEqual(location.name, location.viewName)
    }
    
    func testViewNameWhenLocationNameIsEmpty() {
        let location = Location(name: nil, latitude: 41.9028, longitude: 12.4964)
        XCTAssertEqual("Unknown location name", location.viewName)
    }
    
    func testMapViewCoordinatesFormattedCorrectly() {
        let location = Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        XCTAssertEqual("41.9028, 12.4964", location.viewCoordinates)
    }
}
