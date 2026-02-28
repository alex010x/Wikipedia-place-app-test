//
//  FetchLocationsUseCase.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

/// A use case responsible for retrieving a collection of `Location` models.
///
/// FetchLocationsUseCase coordinates with a data repository conforming to
/// `LocationRepositoryProtocol` to asynchronously fetch all available locations.
/// It acts as a thin domain layer wrapper that abstracts away the underlying
/// data source and exposes a simple API tailored for the application's needs.
///
/// Dependencies:
/// - `LocationRepositoryProtocol`: An abstraction over the data layer that
///   provides methods to fetch `Location` entities.
///
/// Usage:
/// - Initialize with a concrete implementation of `LocationRepositoryProtocol`.
/// - Call `getLocations()` to asynchronously obtain the list of locations.
///
/// Concurrency:
/// - `getLocations()` is `async` and `throws`. It must be called from an
///   asynchronous context and will propagate any errors thrown by the repository.
///
/// Errors:
/// - Propagates any error thrown by the underlying repository implementation.
///
/// Example:
/// ```swift
/// let useCase = FetchLocationsUseCase(repository: someRepository)
/// let locations = try await useCase.getLocations()
/// ```
///
/// - Note: This type conforms to `FetchLocationsUseCaseProtocol` to enable
///   testability and to facilitate dependency inversion across the app.
///
/// - SeeAlso: `LocationRepositoryProtocol`, `Location`
struct FetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    
    let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func getLocations() async throws -> [Location] {
        try await repository.fetchAll()
    }
}
