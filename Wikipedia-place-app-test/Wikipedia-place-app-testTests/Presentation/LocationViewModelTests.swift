//
//  LocationViewModelTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import XCTest
@testable import Wikipedia_place_app_test

@MainActor
final class LocationViewModelTests: XCTestCase {
    
    var sut: LocationViewModel!
    var mockUseCase: MockFetchLocationsUseCase!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockFetchLocationsUseCase()
        sut = LocationViewModel(fetchLocationsUseCase: mockUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    // MARK: - fetchLocations
    
    func testFetchLocationsUpdatesStateToLoaded() async {
        mockUseCase.mockLocations = [Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)]
        
        await sut.fetchLocations()
        
        guard case .loaded = sut.state else {
            XCTFail("Expected loaded state")
            return
        }
    }
    
    func testFetchLocationsUpdatesLocations() async {
        let expectedLocations = [Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)]
        mockUseCase.mockLocations = expectedLocations
        
        await sut.fetchLocations()
        
        XCTAssertEqual(sut.locations.count, 1)
        XCTAssertEqual(sut.locations.first?.name, "Rome")
    }
    
    func testFetchLocationsUpdatesStateToErrorWhenFails() async {
        mockUseCase.shouldThrow = true
        
        await sut.fetchLocations()
        
        guard case .error = sut.state else {
            XCTFail("Expected error state")
            return
        }
    }
    
    func testFetchLocationsKeepsLocationsEmptyWhenFails() async {
        mockUseCase.shouldThrow = true
        
        await sut.fetchLocations()
        
        XCTAssertTrue(sut.locations.isEmpty)
    }
    
    func testInitialStateIsLoading() {
        guard case .loading = sut.state else {
            XCTFail("Expected loading state")
            return
        }
    }
    
    // MARK: - Accessibility
    
    func testAccessibilityLabelWithName() {
        let location = Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        
        let label = sut.getAccessibilityLabel(for: location)
        
        XCTAssertTrue(label.contains("Rome"))
        XCTAssertTrue(label.contains("41.9028"))
        XCTAssertTrue(label.contains("12.4964"))
    }
    
    func testAccessibilityHintWithName() {
        let location = Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        
        let hint = sut.getAccessibilityHint(for: location)
        
        XCTAssertTrue(hint.contains("Rome"))
    }
    
    func testAccessibilityHintWithoutName() {
        let location = Location(name: nil, latitude: 41.9028, longitude: 12.4964)
        
        let hint = sut.getAccessibilityHint(for: location)
        
        XCTAssertTrue(hint.contains("41.9028"))
        XCTAssertTrue(hint.contains("12.4964"))
    }
}
