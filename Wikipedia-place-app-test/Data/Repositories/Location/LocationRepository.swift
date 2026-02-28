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
        let dto: [LocationDTO] = try await networkService
            .networkManager
            .router
            .request(endpoint: LocationEndpoint.pageLocation)
        
        return dto.map { .init(from: $0) }
    }
}
