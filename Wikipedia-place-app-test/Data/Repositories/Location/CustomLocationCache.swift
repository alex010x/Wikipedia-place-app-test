//
//  CustomLocationCache.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

/// Cache for custom user-defined locations.
/// Declared as `Actor` to ensure thread-safe access to the underlying storage
/// without explicit locking.
protocol CustomLocationCacheProtocol: Actor {
    func retrieveAll() -> [LocationDTO]
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
