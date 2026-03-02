//
//  LocationCoordinatorTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest

@MainActor
final class LocationCoordinatorTests: XCTestCase {

    var sut: LocationCoordinator!
    var mockFetchUseCase: MockFetchLocationsUseCase!
    var mockAddUseCase: MockAddCustomLocationUseCase!
    var mockDeeplinkHandler: MockWikipediaDeeplinkService!
    var errorHandler: ErrorHandler!

    override func setUp() {
        super.setUp()
        mockFetchUseCase = MockFetchLocationsUseCase()
        mockAddUseCase = MockAddCustomLocationUseCase()
        mockDeeplinkHandler = MockWikipediaDeeplinkService()
        errorHandler = ErrorHandler()
        sut = LocationCoordinator(
            fetchLocationUseCase: mockFetchUseCase,
            addCustomLocationUseCase: mockAddUseCase,
            deeplinkServiceHandler: mockDeeplinkHandler,
            errorHandler: errorHandler
        )
    }

    override func tearDown() {
        sut = nil
        mockFetchUseCase = nil
        mockAddUseCase = nil
        mockDeeplinkHandler = nil
        errorHandler = nil
        super.tearDown()
    }

    // MARK: - showAddCustomLocation

    func testShowAddCustomLocationSetsSheet() {
        sut.showAddCustomLocation()
        XCTAssertEqual(sut.sheet, .addCustomLocation)
    }

    // MARK: - dismissSheet

    func testDismissSheetClearsSheet() {
        sut.showAddCustomLocation()
        sut.dismissSheet()
        XCTAssertNil(sut.sheet)
    }

    func testDismissSheetWhenAlreadyNilDoesNotCrash() {
        XCTAssertNil(sut.sheet)
        sut.dismissSheet()
        XCTAssertNil(sut.sheet)
    }

    // MARK: - handleLocationTap

    func testHandleLocationTapCallsDeeplinkHandler() async throws {
        let location = Location(name: "Rome", latitude: 41.9, longitude: 12.4)
        sut.handleLocationTap(location)
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertEqual(mockDeeplinkHandler.openedLocations.first, location)
    }

    func testHandleLocationTapSuccessDoesNotSetError() async throws {
        mockDeeplinkHandler.shouldThrow = false
        let location = Location(name: "Rome", latitude: 41.9, longitude: 12.4)
        sut.handleLocationTap(location)
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNil(errorHandler.currentError)
    }

    func testHandleLocationTapWithErrorSetsErrorHandler() async throws {
        mockDeeplinkHandler.shouldThrow = true
        let location = Location(name: "Rome", latitude: 41.9, longitude: 12.4)
        sut.handleLocationTap(location)
        try await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertNotNil(errorHandler.currentError)
    }
    
    func testLocationCoordinatorSheetIdIsRawValue() {
        XCTAssertEqual(LocationCoordinatorSheet.addCustomLocation.id, "addCustomLocation")
    }
}
