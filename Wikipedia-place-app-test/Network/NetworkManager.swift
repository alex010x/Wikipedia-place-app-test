//
//  NetworkManager.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

/// A protocol that defines the behavior of a network manager responsible for executing API requests.
///
/// Types conforming to `NetworkManagerProtocol` coordinate network operations through an injected
/// router, abstracting the underlying transport and request-building details. The protocol exposes
/// a single generic request method that performs an asynchronous call to a specified API endpoint
/// and decodes the response into a concrete `Decodable` type.
///
/// Conformance typically involves delegating to a `RouterProtocol` implementation that constructs
/// `URLRequest` instances and performs the actual network I/O.
///
/// - SeeAlso: `RouterProtocol`, `APIEndpointProtocol`
protocol NetworkManagerProtocol {
    /// The router used to construct and perform network requests.
    ///
    /// This dependency encapsulates details such as base URLs, paths, query parameters,
    /// HTTP methods, headers, and request execution. By injecting a `RouterProtocol`
    /// implementation, you can easily swap transport layers or provide mock routers
    /// for testing.
    var router: RouterProtocol { get }
    
    /// Performs an asynchronous request to the given API endpoint and decodes the response.
    ///
    /// This method delegates to the `router` to build and execute the request for the provided
    /// `endpoint`. Upon receiving a successful response, it attempts to decode the payload into
    /// the specified generic type `T`.
    ///
    /// - Parameters:
    ///   - endpoint: An object conforming to `APIEndpointProtocol` that describes the target request,
    ///               including path, method, parameters, and headers.
    ///
    /// - Returns: A value of type `T` decoded from the response body.
    ///
    /// - Throws: Rethrows any errors encountered during request construction, network transport,
    ///           or decoding, such as connectivity issues, non-2xx HTTP responses, or decoding
    ///           failures.
    ///
    /// - Note: The generic constraint `T: Decodable` requires the response model to conform to
    ///         `Decodable`. Ensure the endpoint and the expected model align with the server's
    ///         response format.
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T
}

/// A concrete implementation of `NetworkManagerProtocol` that coordinates network requests
/// through an injected `RouterProtocol`.
///
/// `NetworkManager` acts as a thin façade over a `RouterProtocol` instance, delegating
/// request construction, execution, and response handling to the router. This design
/// enables dependency injection for testability and flexibility in swapping transport
/// layers or request-building strategies.
///
/// Usage:
/// - Initialize with a router that conforms to `RouterProtocol`.
/// - Call `request(endpoint:)` with an `APIEndpointProtocol` to perform an asynchronous
///   network call and decode the response into a `Decodable` model.
///
/// Threading:
/// - The `request(endpoint:)` method is `async` and should be awaited from an asynchronous
///   context. It performs no explicit threading management, relying on the router and
///   underlying URL loading system.
///
/// Error Handling:
/// - Errors thrown by request creation, transport failures, non-2xx responses, or decoding
///   issues are propagated to the caller.
///
/// - SeeAlso: `NetworkManagerProtocol`, `RouterProtocol`, `APIEndpointProtocol`
///
/// Properties:
/// - `router`: The injected router responsible for building and executing `URLRequest`s.
///
/// Initializers:
/// - `init(router:)`: Designated initializer that injects the router dependency.
///
/// Methods:
/// - `request(endpoint:)`: Executes the request described by the endpoint and decodes
///   the response into the requested `Decodable` type.
final class NetworkManager: NetworkManagerProtocol {
    
    let router: RouterProtocol
    
    required init(router: RouterProtocol) {
        self.router = router
    }
    
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T {
        try await router.request(endpoint: endpoint)
    }
}
