//
//  ErrorHandlerTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import XCTest
import Combine
@testable import Wikipedia_place_app_test

final class ErrorHandlerTests: XCTestCase {
    
    var sut: ErrorHandler!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = ErrorHandler()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        cancellables.removeAll()
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State
    
    func testInitialStateHasNoError() {
        XCTAssertNil(sut.currentError)
    }
    
    // MARK: - handle
    
    func testHandleSetsCurrentError() {
        let error = URLError(.badURL)
        sut.handle(error)
        XCTAssertNotNil(sut.currentError)
    }
    
    func testHandleSetsCorrectError() {
        let error = URLError(.badURL)
        sut.handle(error)
        XCTAssertEqual(sut.currentError as? URLError, error)
    }
    
    func testHandleOverwritesPreviousError() {
        let firstError = URLError(.badURL)
        let secondError = URLError(.timedOut)
        sut.handle(firstError)
        sut.handle(secondError)
        XCTAssertEqual(sut.currentError as? URLError, secondError)
    }
    
    // MARK: - resetState
    
    func testResetStateClearsCurrentError() {
        sut.handle(URLError(.badURL))
        sut.resetState()
        XCTAssertNil(sut.currentError)
    }
    
    // MARK: - @Published
    
    func testHandlePublishesError() {
        let expectation = expectation(description: "currentError published")
        let error = URLError(.badURL)
        
        sut.$currentError
            .dropFirst()
            .sink { receivedError in
                XCTAssertEqual(receivedError as? URLError, error)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.handle(error)
        waitForExpectations(timeout: 1)
    }
    
    func testResetStatePublishesNil() {
        let expectation = expectation(description: "currentError reset to nil")
        
        sut.handle(URLError(.badURL))
        
        sut.$currentError
            .dropFirst()
            .sink { receivedError in
                XCTAssertNil(receivedError)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.resetState()
        waitForExpectations(timeout: 1)
    }
}
