//
//  NetworkRouter.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

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
            // Only HTTP responses carry a status code; non-HTTP responses are treated as valid.
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
            // Wraps the underlying decoding error to preserve the original cause for debugging.
            throw NetworkError.decodingError(error)
        }
    }
}
