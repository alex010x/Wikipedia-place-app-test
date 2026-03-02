//
//  NetworkRouterTests.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import XCTest
@testable import Wikipedia_place_app_test

@MainActor
final class NetworkRouterTests: XCTestCase {
    
    private var mockSession: MockURLSession!
    private var sut: NetworkRouter!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        sut = NetworkRouter(
            session: mockSession,
            configuration: .default
        )
    }
    
    override func tearDown() {
        mockSession = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Success
    
    func testRequestReturnsDecodedModelWhenResponseIsValid() async throws {
        let expectedData = try XCTUnwrap(loadFile("LocationResponse"))
        mockSession.result = .success(expectedData, makeResponse(statusCode: 200))
        
        let result: LocationResponseDTO = try await sut.request(endpoint: LocationEndpoint.pageLocation)
        
        XCTAssertEqual(result.locations.count, 4)
    }
    
    func testRequestCapturesCorrectTimeoutInterval() async throws {
        let data = try XCTUnwrap(loadFile("LocationResponse"))
        mockSession.result = .success(data, makeResponse(statusCode: 200))
        
        let _: LocationResponseDTO = try await sut.request(endpoint: LocationEndpoint.pageLocation)
        
        XCTAssertEqual(mockSession.capturedRequests.first?.timeoutInterval, 15)
    }
    
    // MARK: - Failure
    
    func testRequestThrowsInvalidResponseWhenStatusCodeIs400() async {
        mockSession.result = .success(Data(), makeResponse(statusCode: 400))
        
        do {
            let _: LocationResponseDTO = try await sut.request(endpoint: LocationEndpoint.pageLocation)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            guard case .invalidResponse = error else {
                XCTFail("Expected invalidResponse, got \(error)")
                return
            }
        } catch {
            XCTFail("Expected NetworkError, got \(error)")
        }
    }
    
    func testRequestThrowsInvalidResponseWhenStatusCodeIs500() async {
        mockSession.result = .success(Data(), makeResponse(statusCode: 500))
        
        do {
            let _: LocationResponseDTO = try await sut.request(endpoint: LocationEndpoint.pageLocation)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            guard case .invalidResponse = error else {
                XCTFail("Expected invalidResponse, got \(error)")
                return
            }
        } catch {
            XCTFail("Expected NetworkError, got \(error)")
        }
    }
    
    func testRequestThrowsDecodingErrorWhenDataIsMalformed() async {
        mockSession.result = .success(Data("invalid json".utf8), makeResponse(statusCode: 200))
        
        do {
            let _: LocationResponseDTO = try await sut.request(endpoint: LocationEndpoint.pageLocation)
            XCTFail("Expected error to be thrown")
        } catch let error as NetworkError {
            guard case .decodingError = error else {
                XCTFail("Expected decodingError, got \(error)")
                return
            }
        } catch {
            XCTFail("Expected NetworkError, got \(error)")
        }
    }
    
    func testRequestThrowsWhenSessionFails() async {
        mockSession.result = .failure(URLError(.notConnectedToInternet))
        
        do {
            let _: LocationResponseDTO = try await sut.request(endpoint: LocationEndpoint.pageLocation)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
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
    
    private func loadFile(_ name: String) -> Data? {
        Data.loadFile(name, withExtension: ".json")
    }
}
