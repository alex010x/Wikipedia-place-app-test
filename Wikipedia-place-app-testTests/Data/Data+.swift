//
//  Data+.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import Foundation

extension Data {
    
    static func loadFile(_ name: String, withExtension: String) -> Data? {
        guard let bundle = Bundle(identifier: "test.Wikipedia-place-app-testTests"),
              let url = bundle.url(forResource: name, withExtension: withExtension) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        return data
    }
}
