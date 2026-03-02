//
//  LocationRepository.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

struct LocationRepository: LocationRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let customLocationCache: CustomLocationCacheProtocol
    
    init(
        networkService: NetworkServiceProtocol,
        customLocationCache: CustomLocationCacheProtocol
    ) {
        self.networkService = networkService
        self.customLocationCache = customLocationCache
    }
    
    func fetchAll() async throws -> [Location] {
        let responseDTO: LocationResponseDTO = try await networkService
            .request(endpoint: LocationEndpoint.pageLocation)
        
        let fetchedLocations = responseDTO.locations.map { Location(from: $0) }
        
        // retrieve cached data
        let cachedDTO: [LocationDTO] = await customLocationCache.retrieveAll()
        let cachedLocations = cachedDTO.map { Location(from: $0) }
        
        return fetchedLocations + cachedLocations
    }
    
    func addCustomLocation(_ location: Location) async {
        await customLocationCache.addElement(
            LocationDTO(
                name: location.name,
                latitude: location.latitude,
                longitude: location.longitude
            )
        )
    }
}
