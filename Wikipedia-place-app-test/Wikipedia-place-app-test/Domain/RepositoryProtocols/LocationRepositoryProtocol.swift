//
//  LocationRepositoryProtocol.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

protocol LocationRepositoryProtocol {
    func fetchAll() async throws -> [Location]
    func addCustomLocation(_ location: Location) async
}
