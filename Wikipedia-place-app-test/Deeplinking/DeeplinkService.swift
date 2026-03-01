//
//  DeeplinkService.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import Foundation

protocol WikipediaDeeplinkServiceProtocol {
    func openWikipedia(for location: Location) async throws
}

struct WikipediaDeeplinkService: WikipediaDeeplinkServiceProtocol {
    
    enum DeeplinkError: Error {
        case invalidURL
        case cannotOpenURL
        case cannotDeeplink
    }
    
    enum DeeplinkConstants: String {
        case scheme = "wikipedia"
        case host = "places"
        case queryItemName = "WMFPlacesCoordinates"
    }
    
    private let urlOpener: URLOpenerProtocol
    
    init(urlOpener: URLOpenerProtocol) {
        self.urlOpener = urlOpener
    }
    
    func openWikipedia(for location: Location) async throws {
        guard let url = makeURL(for: location) else {
            throw DeeplinkError.invalidURL
        }
        
        guard urlOpener.canOpen(url) else {
            throw DeeplinkError.cannotOpenURL
        }
        
        guard await urlOpener.open(url) else {
            throw DeeplinkError.cannotDeeplink
        }
    }
    
    private func makeURL(for location: Location) -> URL? {
        let coordinates = Coordinates(latitude: location.latitude, longitude: location.longitude)
        
        guard let data = try? JSONEncoder().encode(coordinates),
              let jsonString = String(data: data, encoding: .utf8)
        else { return nil }
        
        var components = URLComponents()
        components.scheme = DeeplinkConstants.scheme.rawValue
        components.host = DeeplinkConstants.host.rawValue
        components.queryItems = [
            URLQueryItem(name: DeeplinkConstants.queryItemName.rawValue, value: jsonString)
        ]
        return components.url
    }
}
