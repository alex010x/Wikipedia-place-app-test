//
//  NavigationController.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import SwiftUI
import Combine

@MainActor
final class NavigationController: ObservableObject {
    @Published var navigationPath = NavigationPath()

    func push<T: Hashable>(_ route: T) {
        navigationPath.append(route)
    }

    func dismiss() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}
