//
//  LocationCoordinatorRoute.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import Foundation

enum LocationCoordinatorSheet: String, Identifiable {
    var id: String { String(describing: self) }
    case addCustomLocation
}
