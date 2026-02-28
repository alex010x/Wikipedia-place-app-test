//
//  CustomLocationViewModel.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import Combine
import Foundation

final class CustomLocationViewModel: ObservableObject {
    private let useCase: AddCustomLocationUseCaseProtocol
    
    init(useCase: AddCustomLocationUseCaseProtocol) {
        self.useCase = useCase
    }
}
