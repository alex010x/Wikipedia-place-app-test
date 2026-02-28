//
//  LocationDTO.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

struct LocationDTO: Decodable {
    let name: String?
    let latitude: Double
    let longitude: Double
    
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "long"
    }
}
