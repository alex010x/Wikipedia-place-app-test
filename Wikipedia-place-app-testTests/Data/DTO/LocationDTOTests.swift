//
//  LocationDTOTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest

@MainActor
final class LocationDTOTests: XCTestCase {
    var dtoFromFile: DTOFromFileMocks!

    override func setUp() {
        super.setUp()
        dtoFromFile = DTOFromFileMocks()
    }
    
    func testLocationResponseCorrectlyMaps() throws {
        let dtoFromMock: LocationResponseDTO = try XCTUnwrap(dtoFromFile.loadDTOFromJson(file: "LocationResponse"))
        let locations = dtoFromMock.locations
        
        XCTAssertEqual(locations.count, 4)
    }
    
    func testLocationResponseToLocationsDTOMapsCorrectElements() throws {
        let dtoFromMock: LocationResponseDTO = try XCTUnwrap(dtoFromFile.loadDTOFromJson(file: "LocationResponse"))
        let locations = dtoFromMock.locations
        
        let first = try XCTUnwrap(locations.first)
        XCTAssertEqual(first.name, "Amsterdam")
        XCTAssertEqual(first.latitude, 52.3547498)
        XCTAssertEqual(first.longitude, 4.8339215)
    }
    
    func testLocationResponseDTOCorrectlyDecodesOptionalName() throws {
        let dtoFromMock: LocationResponseDTO = try XCTUnwrap(dtoFromFile.loadDTOFromJson(file: "LocationResponse"))
        
        let locationWithoutName = dtoFromMock.locations.first(where: { $0.name == nil })
        XCTAssertNotNil(locationWithoutName)
    }
}
