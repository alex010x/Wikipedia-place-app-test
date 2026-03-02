# Wikipedia-place-app-test
AMRO-Bank test - Wikipedia app deeplinking


## Overview
This app displays a list of geographic locations fetched from a remote service. Users can add custom locations, which are persisted locally in an in-memory cache. Tapping a location opens the Wikipedia app via deep link, showing the selected place on the map.

## Architecture
The project follows MVVM with a Coordinator pattern for navigation, Clean Architecture principles with the separation of presentation, domain, data and network layers, and Protocol-Oriented Programming throughout to maximize testability.


# Key Patterns & Decisions

## Coordinator Pattern
Navigation is fully decoupled from the view layer.

`Coordinator` is a generic protocol requiring a Route type, a rootView, a coordinate method for navigation purposes and a NavigationController. In this specific project I extended coordinator with `Route == Never` as there's no navigation, but added it anyway to show the expected usage of the pattern.
`CoordinatedView` is a thin generic SwiftUI wrapper that binds the coordinator's NavigationPath to a NavigationStack
`NavigationController` is a separate ObservableObject that encapsulates the NavigationPath, designed to be shared across parent/child coordinators.
`LocationCoordinator` owns the `LocationViewModel` lifecycle, handles sheet presentation, and manages deeplink errors

## MVVM
Each screen has a dedicated ViewModel marked @MainActor that owns the business logic and exposes state via @Published properties.

Clean Architecture

Domain: use case protocols and the Location model

Data: LocationRepository coordinates between the remote network service and the local cache, DTO models

Presentation: ViewModels consume use cases via protocol injection

Network: Network layer

## Actor-based Cache
CustomLocationCache is implemented as a Swift actor to guarantee thread-safe access to the in-memory storage without explicit locking. This allows serialized access to it.

## Dependency Injection
All dependencies are composed at the app entry point in WikipediaPlaceApp and injected top-down. No singletons are used except URLSession.shared as the default session.

## Testability
All use cases, services, and repositories are hidden behind protocols.
URLSession is abstracted via `URLSessionDataProtocol` to allow mock network responses in unit tests
`LocationCoordinator`, ViewModels, UseCases, Repositories, `ErrorHandler`, `DeeplinkService` and `NavigationController` all have dedicated unit test suites.
The coordinator ensures navigation logic is testable without involving any SwiftUI views.
Created 2 different entry points for the app, to avoid real app running when executing tests. This, not only is necessary, but also allows to track properly the coverage.

## Accessibility
All interactive elements expose accessibilityLabel and accessibilityHint for VoiceOver. Some error states post AccessibilityNotification.Announcement to notify screen reader users immediately.

## Deeplinking
Tapping a location opens the Wikipedia app via the `wikipedia://places` deep link, passing 
the coordinates as a `WMFPlacesCoordinates` query item. The coordinates are JSON-encoded 
before being appended to the URL, as the Wikipedia app expects a JSON string that it decodes 
back into a `Coordinate` type on its end.

## Tech Stack
- Swift 6
- SwiftUI
- Combine
- Swift Concurrency (async/await, actor)
- XCTest
