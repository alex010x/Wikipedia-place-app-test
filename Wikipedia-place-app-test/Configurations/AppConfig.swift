//
//  AppConfig.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

/// A namespace for application-wide configuration values sourced from the app bundle.
/// 
/// AppConfig centralizes access to static configuration, such as API endpoints,
/// that are defined in the app’s Info.plist. This helps avoid scattering string
/// literals and provides a single source of truth for configuration keys and values.
///
/// Usage:
/// - Define the expected keys (e.g., "API_URL") in your Info.plist.
/// - Access configuration values via static properties like `AppConfig.baseURL`.
///
/// Notes:
/// - Accessing `baseURL` will cause a runtime `fatalError` if the corresponding
///   key is missing or not a `String`. Ensure the Info.plist is correctly configured
///   for all build configurations and targets.
///
/// Private Types:
/// - `Keys`: An internal enum encapsulating Info.plist key names to avoid typos
///   and centralize key string definitions.
///
/// Static Properties:
/// - `baseURL`: The base URL for the app’s API, read from the Info.plist under
///   the "API_URL" key. Crashes at runtime with a descriptive message if the key
///   is missing or not a valid string.
///   
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
