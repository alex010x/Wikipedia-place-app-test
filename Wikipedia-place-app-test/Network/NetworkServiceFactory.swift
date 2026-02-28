//
//  NetworkServiceFactory.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

/// A factory responsible for constructing and configuring the app's networking stack.
///
/// NetworkServiceFactory centralizes the creation of `NetworkService` instances,
/// assembling the required components (`NetworkRouter` and `NetworkManager`)
/// with their default configurations. This ensures consistent networking behavior
/// across the app and simplifies dependency creation for callers.
///
/// Usage:
/// - Call `NetworkServiceFactory.createNetworkService()` to obtain a ready-to-use
///   `NetworkService` configured with a shared `URLSession` and default router settings.
///
/// Design:
/// - The initializer is private to prevent instantiation, as this type is intended
///   to be used solely via its static factory method.
/// - The factory composes:
///   - `NetworkRouter`: initialized with `URLSession.shared` and `.default` configuration,
///     encapsulating low-level request execution.
///   - `NetworkManager`: initialized with the router to provide higher-level networking
///     orchestration and error handling.
///   - `NetworkService`: the public-facing service used by the app to perform network
///     operations.
///
/// - Returns: A fully configured `NetworkService` ready for use.
///
/// - Note: If you need custom session or configuration behavior (e.g., ephemeral sessions,
///   custom caching, or additional headers), consider adding an overload or a parameterized
///   factory method to inject those dependencies.
///   
struct NetworkServiceFactory {
    
    private init() {
        // No-op - no init as factory.
    }
    
    static func createNetworkService() -> NetworkService {
        let networkRouter = NetworkRouter(
            session: URLSession.shared,
            configuration: .default
        )
        let networkManager = NetworkManager(router: networkRouter)
        return NetworkService(networkManager: networkManager)
    }
}
