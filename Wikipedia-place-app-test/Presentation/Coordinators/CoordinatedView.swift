//
//  CoordinatedView.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import SwiftUI

/// Thin adapter between a Coordinator and SwiftUI's NavigationStack.
/// Both coordinator and navigationController must be observed separately
/// because @Published changes in navigationController don't propagate
/// through the coordinator's ObservableObject.
///
struct CoordinatedView<C: Coordinator>: View {
    @ObservedObject private var coordinator: C
    @ObservedObject private var navigationController: NavigationController

    init(_ coordinator: C) {
        self.coordinator = coordinator
        self.navigationController = coordinator.navigationController
    }

    var body: some View {
        NavigationStack(path: $navigationController.navigationPath) {
            coordinator.rootView
        }
    }
}
