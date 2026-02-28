//
//  CustomCache.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

/// A type-erased, actor-isolated cache protocol for storing and managing collections of data transfer objects (DTOs).
///
/// CustomCacheProtocol provides a minimal, concurrency-safe API for:
/// - Retrieving all cached elements
/// - Adding a new element
/// - Clearing the cache
///
/// Conforming types must be actors, ensuring thread-safe access to the underlying storage using Swift Concurrency.
///
/// - Generic Parameter:
///   - T: A DTO type conforming to `DTOProtocol` that represents the elements stored in the cache.
///
/// Usage notes:
/// - Because this protocol refines `Actor`, all method calls must be made with `await`.
/// - The cache is non-persistent and in-memory by design; persistence strategies should be implemented separately.
///
/// Example:
/// ```swift
/// let cache = CustomCache<MyDTO>()
/// await cache.addElement(myDTO)
/// let all = await cache.retrieveAll()
/// await cache.clearCache()
/// ```
///
/// Concurrency:
/// - Actor isolation guarantees safe mutation and access across tasks.
/// - Methods are non-throwing and synchronous within the actor context.
///
///

/// To reviewers:
/// I chose to make the cache generic because the in-memory storage logic is identical regardless of the type — an array, a method to add, one to retrieve, and one to clear. Extracting this into a generic component avoids code duplication in case we need to cache a different type of data in the future, following the DRY principle. The DTOProtocol constraint ensures that only data layer types can be cached, keeping the architectural boundaries correct.
protocol CustomCacheProtocol<T>: Actor {
    associatedtype T: DTOProtocol
    func retrieveAll() -> [T]
    func addElement(_ element: T)
    func clearCache()
}

actor CustomCache<T: DTOProtocol>: CustomCacheProtocol {
    
    private var elements = [T]()
    
    func retrieveAll() -> [T] {
        elements
    }
    
    func addElement(_ element: T) {
        elements.append(element)
    }
    
    func clearCache() {
        elements.removeAll()
    }
}
