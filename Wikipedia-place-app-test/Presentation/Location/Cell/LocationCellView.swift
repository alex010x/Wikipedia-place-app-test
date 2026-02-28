//
//  LocationCellView.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import SwiftUI

struct LocationCellView: View {
    
    let name: String
    let coordinates: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.headline)
            Text(coordinates)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
