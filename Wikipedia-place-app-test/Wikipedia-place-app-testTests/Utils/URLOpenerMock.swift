//
//  URLOpenerMock.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import Foundation
@testable import Wikipedia_place_app_test

@MainActor
final class MockURLOpener: URLOpenerProtocol {
    
    var openedURLs: [URL] = []
    var canOpenResult: Bool = true
    var openResult: Bool = true
    
    func open(_ url: URL) async -> Bool {
        openedURLs.append(url)
        return openResult
    }
    
    func canOpen(_ url: URL) -> Bool {
        canOpenResult
    }
}
