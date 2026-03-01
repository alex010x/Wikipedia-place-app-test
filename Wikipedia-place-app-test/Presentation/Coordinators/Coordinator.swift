//
//  Coordinator.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import SwiftUI

protocol Coordinator: ObservableObject {
    associatedtype Route: Hashable
    associatedtype Destination: View
    associatedtype RootView: View

    var navigationController: NavigationController { get }

    @ViewBuilder func coordinate(_ route: Route) -> Destination
    @ViewBuilder var rootView: RootView { get }
}
