//
//  NetworkRouter.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

/// A concrete implementation of `RouterProtocol` responsible for executing network requests
/// and decoding responses into strongly typed models.
///
/// NetworkRouter encapsulates the details of constructing URL requests using an
/// `APIEndpointProtocol`, executing them via an abstracted `URLSessionDataProtocol`,
/// validating HTTP responses, and decoding the resulting data into `Decodable` types.
/// It is initialized with a configurable session and a `NetworkServiceConfiguration`
/// to control behaviors like timeout intervals.
///
/// Usage:
/// - Provide a session conforming to `URLSessionDataProtocol` (defaults to `URLSession.shared`)
///   to enable easy dependency injection and unit testing.
/// - Provide a `NetworkServiceConfiguration` to tune request parameters.
/// - Call `request(endpoint:)` with an object conforming to `APIEndpointProtocol` to fetch and decode data.
///
/// Errors:
/// - Throws `NetworkError.invalidResponse` when the HTTP status code is not in 200..<300.
/// - Throws `NetworkError.decodingError` when JSON decoding fails.
///
/// Concurrency:
/// - `request(endpoint:)` is async and can be awaited from async contexts.
///
/// Dependencies (required types not shown here):
/// - `RouterProtocol`: The protocol that defines the router interface.
/// - `URLSessionDataProtocol`: An abstraction over URLSession data tasks for testability.
/// - `NetworkServiceConfiguration`: Provides configuration values like timeoutInterval.
/// - `APIEndpointProtocol`: Builds a configured `URLRequest` from an endpoint definition.
/// - `AppConfig.baseURL`: The base URL used to construct endpoint requests.
/// - `NetworkError`: Error enumeration for network-related failures.
///
/// Example:
/// ```swift
/// let router = NetworkRouter(configuration: config)
/// let model: MyDecodable = try await router.request(endpoint: MyEndpoint())
/// ```
final class NetworkRouter: RouterProtocol {
    let session: URLSessionDataProtocol
    let configuration: NetworkServiceConfiguration
    
    init(session: URLSessionDataProtocol = URLSession.shared,
         configuration: NetworkServiceConfiguration) {
        self.session = session
        self.configuration = configuration
    }
    
    /// Perform request
    func request<T: Decodable>(endpoint: APIEndpointProtocol) async throws -> T {
        var request = try endpoint.createURLRequest(baseURL: AppConfig.baseURL)
        request.timeoutInterval = configuration.timeoutInterval
        
        let (data, response) = try await session.data(for: request)
        
        if let httpURLResponse = response as? HTTPURLResponse {
            if !(200..<300 ~= httpURLResponse.statusCode) {
                throw NetworkError.invalidResponse
            }
        }
        
        return try decodeResponse(data: data)
    }
    
    /// Decode received response
    private func decodeResponse<T: Decodable>(data: Data) throws -> T {
        do {
            let jsonDecoder = JSONDecoder()
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
