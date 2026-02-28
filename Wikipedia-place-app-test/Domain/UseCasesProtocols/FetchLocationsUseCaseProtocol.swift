//
//  FetchLocationsUseCaseProtocol.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

protocol FetchLocationsUseCaseProtocol {
    func getLocations() async throws -> [Location]
}
