//
//  LocationRepository.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

struct LocationRepository: LocationRepositoryProtocol {
    
    let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol
    ) {
        self.networkService = networkService
    }
    
    func fetchAll() async throws -> [Location] {
        let dto: LocationResponseDTO = try await networkService
            .networkManager
            .router
            .request(endpoint: LocationEndpoint.pageLocation)
        
        return dto.locations.map { Location(from: $0) }
    }
}
