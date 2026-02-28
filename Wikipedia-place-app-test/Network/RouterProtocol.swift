//
//  RouterProtocol.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

/// Routing interface
/// A protocol that defines the routing layer for performing network requests.
///
/// Conforming types are responsible for:
/// - Providing a URL session abstraction to facilitate mocking and testing.
/// - Holding a network configuration that describes base URLs, headers, and other request policies.
/// - Executing typed requests against API endpoints and decoding responses.
///
/// The router acts as a thin layer between higher-level services and the underlying `URLSession`
/// infrastructure, encapsulating request construction, execution, and response decoding.

/// The URL session used to execute requests.
///
/// This is an abstraction over `URLSession` to enable dependency injection and unit testing.
/// By depending on `URLSessionDataProtocol` instead of `URLSession` directly, we can provide
/// mock implementations that simulate network behavior without performing real I/O.

/// The configuration that governs how requests are built and sent.
///
/// Typical responsibilities include:
/// - Base URL or host configuration
/// - Default headers
/// - Timeout or caching policies
/// - Environment selection (e.g., staging vs. production)
///
/// Conforming routers use this configuration to construct consistent, reusable requests.

/// Sends a request to the given endpoint and decodes the response into the specified type.
///
/// - Parameters:
///   - endpoint: An object describing the API target, including path, method, query, headers, and body.
/// - Returns: A value of type `T` decoded from the response body.
/// - Throws:
///   - An error if the request cannot be created or executed.
///   - A decoding error if the response cannot be decoded into `T`.
///   - Any transport or server-side errors surfaced by the underlying session.
/// - Note:
///   The generic type `T` must conform to `Decodable`. Consider using lightweight response
///   DTOs to keep decoding resilient and maintainable.
protocol RouterProtocol {
    var session: URLSessionDataProtocol { get }
    var configuration: NetworkServiceConfiguration { get }
    
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T
}

protocol URLSessionDataProtocol {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
}

extension URLSessionDataProtocol {
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)? = nil
    ) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: delegate)
    }
}

extension URLSession: URLSessionDataProtocol {}
