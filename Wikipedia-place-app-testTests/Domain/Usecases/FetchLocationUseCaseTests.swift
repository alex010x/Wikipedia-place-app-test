//
//  FetchLocationUseCaseTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest

@MainActor
final class FetchLocationsUseCaseTests: XCTestCase {
    
    var sut: FetchLocationsUseCase!
    var mockRepository: MockLocationRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockLocationRepository()
        sut = FetchLocationsUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testGetLocationsReturnsLocationsFromRepository() async throws {
        mockRepository.mockLocations = [
            Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        ]
        
        let locations = try await sut.getLocations()
        
        XCTAssertEqual(locations.count, 1)
        XCTAssertEqual(locations.first?.name, "Rome")
        XCTAssertEqual(locations.first?.latitude, 41.9028)
        XCTAssertEqual(locations.first?.longitude, 12.4964)
    }
    
    func testGetLocationsThrowsWhenRepositoryFails() async {
        mockRepository.shouldThrow = true
        
        do {
            _ = try await sut.getLocations()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
