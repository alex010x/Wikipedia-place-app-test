//
//  Location.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import Foundation

struct Location: Hashable {
    
    let name: String?
    let latitude: Double
    let longitude: Double
    
    init(
        from DTO: LocationDTO
    ) {
        self.name = DTO.name
        self.latitude = DTO.latitude
        self.longitude = DTO.longitude
    }
    
    init(
        name: String?,
        latitude: Double,
        longitude: Double
    ) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
