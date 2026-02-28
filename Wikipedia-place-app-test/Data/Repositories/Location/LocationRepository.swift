//
//  LocationRepository.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

/// A concrete repository responsible for fetching location data from a remote source.
///
/// LocationRepository coordinates with an injected `NetworkServiceProtocol` to perform
/// network requests and map the received Data Transfer Objects (DTOs) into domain models.
/// It conforms to `LocationRepositoryProtocol`, exposing an async API to retrieve locations.
///
/// Dependencies:
/// - `NetworkServiceProtocol`: Provides access to a `networkManager` and its `router` to perform requests.
/// - Expects the network layer to return a `LocationResponseDTO`, which is then transformed into `[Location]`.
///
/// Usage:
/// - Initialize with a concrete implementation of `NetworkServiceProtocol`.
/// - Call `fetchAll()` to asynchronously retrieve all available `Location` items.
///
/// Threading:
/// - `fetchAll()` is `async` and can be awaited from asynchronous contexts.
///
/// Error handling:
/// - `fetchAll()` is `throws` and will propagate errors originating from the network layer
///   or decoding failures.
///
/// Mapping:
/// - Converts the received `LocationResponseDTO` into an array of `Location` domain models
///   by mapping each contained DTO element via `Location(from:)`.
///
/// Example:
/// ```swift
/// let repository = LocationRepository(networkService: networkService)
/// let locations = try await repository.fetchAll()
/// ```
///
/// - SeeAlso: `LocationRepositoryProtocol`, `NetworkServiceProtocol`, `LocationResponseDTO`, `Location`, `LocationEndpoint`
/// 
struct LocationRepository: LocationRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let customLocationCache: any CustomCacheProtocol<LocationDTO>
    
    init(
        networkService: NetworkServiceProtocol,
        customLocationCache: any CustomCacheProtocol<LocationDTO>
    ) {
        self.networkService = networkService
        self.customLocationCache = customLocationCache
    }
    
    func fetchAll() async throws -> [Location] {
        let responseDTO: LocationResponseDTO = try await networkService
            .networkManager
            .router
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
