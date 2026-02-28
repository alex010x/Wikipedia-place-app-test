//
//  Coordinator.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

protocol CoordinatorNavigation: AnyObject {
    func navigate(to destination: any Destination)
}

protocol Destination: Identifiable, Hashable {
    var id: String { get }
}

extension Destination {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
