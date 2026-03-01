//
//  Untitled.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import Foundation

@MainActor
protocol LocationCoordinatorProtocol {
    func showAddCustomLocation()
    func dismissSheet()
    func handleLocationTap(_ location: Location)
}
