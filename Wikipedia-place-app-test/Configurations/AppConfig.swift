//
//  AppConfig.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

enum AppConfig {
    
    private enum Keys: String {
        case apiURL = "API_URL"
    }
    
    static var baseURL: String {
        guard let url = Bundle.main.infoDictionary?[Keys.apiURL.rawValue] as? String else {
            fatalError("API_URL not found in plist")
        }
        return url
    }
}
