//
//  LocationResponseDTO.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

struct LocationResponseDTO: Decodable {
    let locations: [LocationDTO]
}
