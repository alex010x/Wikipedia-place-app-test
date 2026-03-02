//
//  NavigationControllerTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest
import SwiftUI

@MainActor
final class NavigationControllerTests: XCTestCase {
    var sut: NavigationController!
    
    override func setUp() {
        super.setUp()
        sut = NavigationController()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialStateIsEmpty() {
        XCTAssertTrue(sut.navigationPath.isEmpty)
    }
    
    // MARK: - Push
    
    func testPushAppendsRouteIntoPath() {
        sut.push("route")
        XCTAssertEqual(sut.navigationPath.count, 1)
    }
    
    func testPushMultipleRoutesIntoPathIncreasesCount() {
        sut.push("route")
        sut.push("second_route")
        XCTAssertEqual(sut.navigationPath.count, 2)
    }
    
    // MARK: - Pop
    
    func testDismissOnEmptyPathDoesNotCrash() {
        XCTAssertTrue(sut.navigationPath.isEmpty)
        sut.dismiss()
        XCTAssertTrue(sut.navigationPath.isEmpty)
    }
    
    func testDismissOnNonEmptyPathReducesCountByOne() {
        sut.push("route")
        XCTAssertEqual(sut.navigationPath.count, 1)
        sut.dismiss()
        XCTAssertTrue(sut.navigationPath.isEmpty)
    }
    
    func testDismissRemovesOnlyLastRoute() {
        sut.push("first_route")
        sut.push("last_route")
        sut.dismiss()
        XCTAssertEqual(sut.navigationPath.count, 1)
    }
    
    // MARK: - pop to root
    
    func testPopToRootOnEmptyPathDoesNotCrash() {
        XCTAssertTrue(sut.navigationPath.isEmpty)
        sut.popToRoot()
        XCTAssertTrue(sut.navigationPath.isEmpty)
    }
    
    func testPopToRootRemovesAllRoutesFromPath() {
        sut.push("first_route")
        sut.push("second_route")
        sut.push("third_route")
        
        sut.popToRoot()
        
        XCTAssertTrue(sut.navigationPath.isEmpty)
    }
}
