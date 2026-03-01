//
//  CustomLocationCache.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

/// A concurrency-safe cache abstraction for storing and retrieving `LocationDTO` values.
/// 
/// Conforming types must be actors to guarantee thread-safe access to the cached elements.
/// This protocol defines minimal operations needed to interact with the cache: retrieving all
/// cached items, adding a new item. Implementations are expected to
/// preserve insertion order unless otherwise documented.
protocol CustomLocationCacheProtocol: Actor {
    /// Returns the current snapshot of all cached `LocationDTO` elements.
    ///
    /// - Important: Since conforming types are actors, calling this method is an asynchronous,
    ///   actor-isolated operation. Use `await` when invoking from outside the actor context.
    /// - Returns: An array containing all cached `LocationDTO` instances.
    func retrieveAll() -> [LocationDTO]
    
    /// Adds a `LocationDTO` element to the cache.
    ///
    /// - Parameter element: The `LocationDTO` to insert into the cache.
    /// - Important: This mutates the cache and must be invoked with `await` from
    ///   outside the actor context to respect actor isolation.
    func addElement(_ element: LocationDTO)
}

actor CustomLocationCache: CustomLocationCacheProtocol {
    
    private var elements = [LocationDTO]()
    
    func retrieveAll() -> [LocationDTO] {
        elements
    }
    
    func addElement(_ element: LocationDTO) {
        elements.append(element)
    }
}
