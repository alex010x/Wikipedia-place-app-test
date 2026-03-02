//
//  AddCustomLocationUseCaseTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest

@MainActor
final class AddCustomLocationUseCaseTests: XCTestCase {
    
    var sut: AddCustomLocationUseCase!
    var mockRepository: MockLocationRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockLocationRepository()
        sut = AddCustomLocationUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testGetLocationsReturnsLocationsFromRepositoryWhenEmpty() async throws {
        let location = Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        
        await sut.addCustomLocation(
            name: location.name,
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        XCTAssertEqual(mockRepository.mockLocations.count, 1)
        XCTAssertEqual(mockRepository.mockLocations.last?.name, "Rome")
        XCTAssertEqual(mockRepository.mockLocations.last?.latitude, 41.9028)
        XCTAssertEqual(mockRepository.mockLocations.last?.longitude, 12.4964)
    }
    
    func testGetLocationsReturnsLocationsFromRepositoryWhenNonEmpty() async throws {
        mockRepository.mockLocations = [
            Location(name: "Amsterdam", latitude: 12.4964, longitude: 28.2132)
        ]
        
        let location = Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        
        await sut.addCustomLocation(
            name: location.name,
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        XCTAssertEqual(mockRepository.mockLocations.count, 2)
        XCTAssertEqual(mockRepository.mockLocations.last?.name, "Rome")
        XCTAssertEqual(mockRepository.mockLocations.last?.latitude, 41.9028)
        XCTAssertEqual(mockRepository.mockLocations.last?.longitude, 12.4964)
    }
}
