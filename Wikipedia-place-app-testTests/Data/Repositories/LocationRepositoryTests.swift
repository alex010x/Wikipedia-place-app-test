//
//  LocationRepositoryTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import XCTest

@MainActor
final class LocationRepositoryTests: XCTestCase {
    
    var sut: LocationRepository!
    var mockSession: MockURLSession!
    var mockCache: CustomLocationCache!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        mockCache = CustomLocationCache()
        let router = NetworkRouter(session: mockSession, configuration: .default)
        let networkService = NetworkService(router: router)
        sut = LocationRepository(networkService: networkService,
                                 customLocationCache: mockCache)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        mockCache = nil
        super.tearDown()
    }
    
    // MARK: - fetchAll
    
    func testFetchAllReturnsRemoteLocations() async throws {
        mockSession.result = .success(
            Data.loadFile("LocationResponse", withExtension: "json")!,
            makeResponse(statusCode: 200)
        )
        
        let locations = try await sut.fetchAll()
        
        XCTAssertEqual(locations.count, 4)
    }
    
    func testFetchAllReturnsBothRemoteAndCachedLocations() async throws {
        mockSession.result = .success(
            Data.loadFile("LocationResponse", withExtension: "json")!,
            makeResponse(statusCode: 200)
        )
        await mockCache.addElement(LocationDTO(name: "Custom", latitude: 80.0, longitude: 70.0))
        
        let locations = try await sut.fetchAll()
        
        XCTAssertEqual(locations.count, 5) // 4 remote + 1 cached
    }
    
    func testFetchAllThrowsWhenNetworkFails() async {
        mockSession.result = .failure(URLError(.notConnectedToInternet))
        
        do {
            _ = try await sut.fetchAll()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    // MARK: - addCustomLocation
    
    func testAddCustomLocationAddsToCache() async throws {
        let location = Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        
        await sut.addCustomLocation(location)
        
        let cached = await mockCache.retrieveAll()
        XCTAssertEqual(cached.count, 1)
        XCTAssertEqual(cached.first?.name, "Rome")
        XCTAssertEqual(cached.first?.latitude, 41.9028)
        XCTAssertEqual(cached.first?.longitude, 12.4964)
    }
    
    // MARK: - Helpers
    
    private func makeResponse(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: AppConfig.baseURL)!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
