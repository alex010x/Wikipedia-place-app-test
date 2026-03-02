//
//  NetworkServiceConfiguration.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

/// Struct NetworkServiceConfiguration is responsable for configuration such as:
/// - timeoutInterval - time out for request
/// - urlSessionConfiguration - configurator of the URLSessionConfiguration
///
struct NetworkServiceConfiguration {
    let timeoutInterval: TimeInterval
    let urlSessionConfiguration: URLSessionConfiguration

    init(
        timeoutInterval: TimeInterval,
        urlSessionConfiguration: URLSessionConfiguration
    ) {
        self.timeoutInterval = timeoutInterval
        self.urlSessionConfiguration = urlSessionConfiguration
    }
}

// MARK: -

extension NetworkServiceConfiguration {
    
    static let `default`: NetworkServiceConfiguration = {
        return NetworkServiceConfiguration(
            timeoutInterval: 15.0,
            urlSessionConfiguration: defaultURLConfiguration
        )
    }()
    
    static let defaultURLConfiguration: URLSessionConfiguration = {
        var configuration = URLSessionConfiguration.ephemeral
        return configuration
    }()
}
