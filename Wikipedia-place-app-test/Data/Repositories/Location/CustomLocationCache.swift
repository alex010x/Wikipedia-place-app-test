//
//  CustomLocationCache.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

protocol CustomLocationCacheProtocol: Actor {
    func retrieveAll() -> [LocationDTO]
    func addElement(_ element: LocationDTO)
    func clearCache()
}

actor CustomLocationCache: CustomLocationCacheProtocol {
    
    private var elements = [LocationDTO]()
    
    func retrieveAll() -> [LocationDTO] {
        elements
    }
    
    func addElement(_ element: LocationDTO) {
        elements.append(element)
    }
    
    func clearCache() {
        elements.removeAll()
    }
}
