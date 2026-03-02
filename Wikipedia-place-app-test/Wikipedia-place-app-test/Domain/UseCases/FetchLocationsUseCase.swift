//
//  FetchLocationsUseCase.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

struct FetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    
    let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func getLocations() async throws -> [Location] {
        try await repository.fetchAll()
    }
}
