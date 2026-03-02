//
//  Wikipedia_place_app_testApp.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 26/02/26.
//

import SwiftUI

@main
struct Wikipedia_place_app_testApp {
    
    static func main() {
        if isProduction {
            WikipediaPlaceApp.main()
        } else {
            WikipediaPlaceAppTest.main()
        }
    }
    
    private static var isProduction: Bool {
        return NSClassFromString("XCTestCase") == nil // check if we're running tests
    }
}
