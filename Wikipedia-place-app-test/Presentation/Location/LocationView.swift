//
//  LocationView.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import SwiftUI

struct LocationView: View {
    
    @ObservedObject var viewModel: LocationViewModel
    let onLocationTap: (Location) -> Void
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                loadingView
            case .loaded:
                loadedView
            case .error(let error):
                makeErrorView(for: error)
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .accessibilityLabel(viewModel.accessibilityLoadingLocations)
            .task {
                await viewModel.fetchLocations()
            }
    }
    
    private var loadedView: some View {
        List {
            ForEach(viewModel.locations, id: \.self) { location in
                LocationCellView(
                    name: location.viewName,
                    coordinates: location.viewCoordinates
                )
                .onTapGesture {
                    onLocationTap(location)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel(viewModel.getAccessibilityLabel(for: location))
                .accessibilityHint(viewModel.getAccessibilityHint(for: location))
            }
        }
        .refreshable {
            await viewModel.fetchLocations()
        }
    }
    
    private func makeErrorView(for error: Error) -> some View {
        VStack {
            Text(error.localizedDescription)
                .accessibilityLabel(error.localizedDescription)
            Button {
                Task {
                    await viewModel.fetchLocations()
                }
            } label: {
                Text(viewModel.retryButtonText)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel(viewModel.retryButtonText)
        }
        .accessibilityElement(children: .combine)
        .onAppear {
            AccessibilityNotification.Announcement(
                viewModel.accessibilityRequestFailureAnnouncement
            ).post()
        }
    }
}
