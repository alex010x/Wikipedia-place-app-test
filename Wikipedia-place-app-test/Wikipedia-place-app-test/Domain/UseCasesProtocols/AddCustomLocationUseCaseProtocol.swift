//
//  AddCustomLocationUseCaseProtocol.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

protocol AddCustomLocationUseCaseProtocol {
    func addCustomLocation(
        name: String?,
        latitude: Double,
        longitude: Double
    ) async
}
