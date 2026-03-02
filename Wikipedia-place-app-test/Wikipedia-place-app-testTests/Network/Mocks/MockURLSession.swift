//
//  MockURLSession.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

@testable import Wikipedia_place_app_test
import Foundation

final class MockURLSession: URLSessionDataProtocol {
    enum MockResult {
        case success(Data, URLResponse)
        case failure(Error)
    }
    
    var result: MockResult = .failure(URLError(.unknown))
    var capturedRequests: [URLRequest] = []

    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse) {
        capturedRequests.append(request)
        switch result {
        case .success(let data, let response):
            return (data, response)
        case .failure(let error):
            throw error
        }
    }
}
