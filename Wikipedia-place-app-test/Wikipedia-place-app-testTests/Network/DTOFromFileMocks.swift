//
//  DTOFromFileMocks.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import Foundation

struct DTOFromFileMocks {
    
    func loadDTOFromJson<T: Decodable>(file: String) -> T? {
        guard let jsonData = Data.loadFile(file, withExtension: "json") else {
            return nil
        }
        let response = try? JSONDecoder().decode(T.self, from: jsonData)
        return response
    }
}
