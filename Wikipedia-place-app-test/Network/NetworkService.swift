//
//  NetworkService.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import Foundation

protocol NetworkServiceProtocol {
    var networkManager: NetworkManagerProtocol { get }
}

struct NetworkService: NetworkServiceProtocol {
    
    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}
