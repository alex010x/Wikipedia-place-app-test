//
//  LocationDTO.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

/// A data transfer object representing a geographic location as received from an external source.
///
/// LocationDTO is designed for decoding JSON payloads that describe a place with an optional
/// display name and precise geographic coordinates. It conforms to `Decodable` and maps
/// external keys to Swift properties via a custom `CodingKeys` enumeration.
///
/// - Note: The JSON keys are expected to be:
///   - `"name"` for the optional display name
///   - `"lat"` for the latitude value
///   - `"long"` for the longitude value
///
/// Properties:
/// - `name`: An optional human-readable name of the location, if provided by the source.
/// - `latitude`: The latitude component of the location in decimal degrees. Positive values indicate
///   the northern hemisphere; negative values indicate the southern hemisphere.
/// - `longitude`: The longitude component of the location in decimal degrees. Positive values indicate
///   the eastern hemisphere; negative values indicate the western hemisphere.
///
/// Decoding behavior:
/// - Uses `CodingKeys` to map `latitude` from `"lat"` and `longitude` from `"long"`.
/// - `name` is optional and will be `nil` if the key is missing or its value is `null`.
///

protocol DTOProtocol: Decodable {}

struct LocationDTO: DTOProtocol {
    let name: String?
    let latitude: Double
    let longitude: Double
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}
