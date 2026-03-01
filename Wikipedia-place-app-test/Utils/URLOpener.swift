//
//  URLOpener.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import Foundation
import SwiftUI

@MainActor
protocol URLOpenerProtocol {
    func open(_ url: URL) async -> Bool
    func canOpen(_ url: URL) -> Bool
}

struct URLOpener: URLOpenerProtocol {
    
    func open(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
    
    func canOpen(_ url: URL) -> Bool {
        UIApplication.shared.canOpenURL(url)
    }
}
