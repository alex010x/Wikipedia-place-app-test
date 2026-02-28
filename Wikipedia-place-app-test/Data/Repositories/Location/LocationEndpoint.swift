//
//  LocationEndpoint.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import Foundation

/// An enumeration that defines the available endpoints related to location data
/// within the app's networking layer.
///
/// LocationEndpoint conforms to `APIEndpointProtocol` to provide all the
/// information required to build a `URLRequest` for each case, such as the
/// path, HTTP method, parameters, headers, query items, cache policy, and
/// timeout.
///
/// Cases:
/// - `pageLocation`: Retrieves a JSON payload containing a collection of
///   locations. This typically maps to a static or bundled resource at
///   `/locations.json`.
///
/// Behavior:
/// - `path`: Returns the relative API path for the endpoint. For `pageLocation`,
///   this is `/locations.json`.
/// - `method`: Uses the HTTP GET method for `pageLocation`, as it is a read-only
///   fetch of location data.
/// - `parametersType`: Declares `.json` to indicate that parameters (if any)
///   would be encoded as JSON. For `pageLocation`, no parameters are used.
/// - `parameters`: Returns `nil` because `pageLocation` does not require a
///   request body.
/// - `headers`: Returns `nil` by default, implying no custom headers are needed
///   for this endpoint. Headers can be added at a higher layer if required
///   (e.g., auth).
/// - `queryItems`: Returns `nil` because `pageLocation` does not accept query
///   parameters. Extend this if pagination or filtering is introduced.
/// - `cachePolicy`: Uses `.reloadIgnoringLocalCacheData` to ensure the freshest
///   data is fetched rather than relying on cached responses.
/// - `timeoutInterval`: Returns `nil`, deferring to the session’s default
///   timeout. Provide a specific value here to override per-endpoint timeouts.
///
/// Conformance:
/// - `APIEndpointProtocol`: Requires the endpoint to expose request-building
///   metadata (path, method, encoding type, etc.).
///
/// Notes:
/// - This endpoint is designed to be simple and static. If the locations source
///   moves to a remote service, consider adding environment-aware base URLs,
///   authentication headers, and query parameters for filtering or pagination.
enum LocationEndpoint: APIEndpointProtocol {
    
    case pageLocation
    
    var path: String {
        switch self {
        case .pageLocation:
            return "/locations.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .pageLocation:
            return .get
        }
    }
    
    var parametersType: HTTPParametersType {
        return .json
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalCacheData
    }
    
    var timeoutInterval: TimeInterval? {
        return nil
    }
}
