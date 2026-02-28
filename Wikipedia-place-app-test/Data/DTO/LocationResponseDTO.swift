//
//  LocationResponseDTO.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

/// A data transfer object (DTO) representing the top-level response for a locations API request.
///
/// This model is designed to decode JSON payloads that return a collection of location items.
/// It conforms to `Decodable` to support automatic decoding from JSON responses.
///
/// Expected JSON structure example:
/// {
///   "locations": [
///     { /* LocationDTO object */ },
///     { /* LocationDTO object */ }
///   ]
/// }
///
/// - Properties:
///   - locations: An array of `LocationDTO` objects decoded from the "locations" field in the response.
///
/// - Note:
///   Ensure that `LocationDTO` also conforms to `Decodable` and matches the JSON schema provided by the API.
///   
struct LocationResponseDTO: Decodable {
    let locations: [LocationDTO]
}
