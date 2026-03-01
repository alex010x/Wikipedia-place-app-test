//
//  CustomLocationViewModelTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import XCTest
import Combine
@testable import Wikipedia_place_app_test

@MainActor
final class CustomLocationViewModelTests: XCTestCase {
    
    var sut: CustomLocationViewModel!
    var mockUseCase: MockAddCustomLocationUseCase!
    var onAddNewLocationCalled: Bool!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockAddCustomLocationUseCase()
        onAddNewLocationCalled = false
        sut = CustomLocationViewModel(
            useCase: mockUseCase,
            onAddNewLocation: { [weak self] in
                self?.onAddNewLocationCalled = true
            }
        )
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    // MARK: - isFormValid
    
    func testIsFormValidWithValidLatitudeAndLongitudeReturnsTrue() {
        sut.latitude = "41.9028"
        sut.longitude = "12.4964"
        XCTAssertTrue(sut.isFormValid)
    }
    
    func testIsFormValidWithInvalidLatitudeReturnsFalse() {
        sut.latitude = "abc"
        sut.longitude = "12.4964"
        XCTAssertFalse(sut.isFormValid)
    }
    
    func testIsFormValidWithLatitudeOutOfRangeReturnsFalse() {
        sut.latitude = "91"
        sut.longitude = "12.4964"
        XCTAssertFalse(sut.isFormValid)
    }
    
    func testIsFormValidWithInvalidLongitudeReturnsFalse() {
        sut.latitude = "41.9028"
        sut.longitude = "abc"
        XCTAssertFalse(sut.isFormValid)
    }
    
    func testIsFormValidWithLongitudeOutOfRangeReturnsFalse() {
        sut.latitude = "41.9028"
        sut.longitude = "181"
        XCTAssertFalse(sut.isFormValid)
    }
    
    func testIsFormValidWithBoundaryLatitudeReturnsTrue() {
        sut.latitude = "90"
        sut.longitude = "0"
        XCTAssertTrue(sut.isFormValid)
    }
    
    func testIsFormValidWithBoundaryLongitudeReturnsTrue() {
        sut.latitude = "0"
        sut.longitude = "180"
        XCTAssertTrue(sut.isFormValid)
    }
    
    // MARK: - errorMessage
    
    func testErrorMessageWithInvalidLatitudeReturnsLatitudeError() {
        sut.latitude = "abc"
        sut.longitude = "12.4964"
        XCTAssertEqual(sut.errorMessage, "Latitude must be a number between -90 and 90.")
    }
    
    func testErrorMessageWithInvalidLongitudeReturnsLongitudeError() {
        sut.latitude = "41.9028"
        sut.longitude = "abc"
        XCTAssertEqual(sut.errorMessage, "Longitude must be a number between -180 and 180.")
    }
    
    func testErrorMessageWithValidCoordinatesReturnsEmptyString() {
        sut.latitude = "41.9028"
        sut.longitude = "12.4964"
        XCTAssertEqual(sut.errorMessage, "")
    }
    
    // MARK: - onAddTapped
    
    func testOnAddTappedWithInvalidCoordinatesSetsShowErrorTrue() {
        sut.latitude = "abc"
        sut.longitude = "12.4964"
        sut.onAddTapped()
        XCTAssertTrue(sut.showError)
    }
    
    func testOnAddTappedWithInvalidCoordinatesDoesNotCallUseCase() {
        sut.latitude = "abc"
        sut.longitude = "12.4964"
        sut.onAddTapped()
        XCTAssertTrue(mockUseCase.mockLocations.isEmpty)
    }
    
    func testOnAddTappedWithValidCoordinatesDoesNotSetShowError() {
        sut.latitude = "41.9028"
        sut.longitude = "12.4964"
        sut.onAddTapped()
        XCTAssertFalse(sut.showError)
    }
    
    func testOnAddTappedWithValidCoordinatesCallsUseCase() async throws {
        sut.latitude = "41.9028"
        sut.longitude = "12.4964"
        sut.name = "Rome"
        sut.onAddTapped()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(mockUseCase.mockLocations.count, 1)
        XCTAssertEqual(mockUseCase.mockLocations.first?.name, "Rome")
        XCTAssertEqual(mockUseCase.mockLocations.first?.latitude, 41.9028)
        XCTAssertEqual(mockUseCase.mockLocations.first?.longitude, 12.4964)
    }
    
    func testOnAddTappedWithEmptyNamePassesNilToUseCase() async throws {
        sut.latitude = "41.9028"
        sut.longitude = "12.4964"
        sut.name = ""
        sut.onAddTapped()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertNil(mockUseCase.mockLocations.first?.name)
    }
    
    func testOnAddTappedWithValidCoordinatesCallsOnAddNewLocation() async throws {
        sut.latitude = "41.9028"
        sut.longitude = "12.4964"
        sut.onAddTapped()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(onAddNewLocationCalled)
    }
}
