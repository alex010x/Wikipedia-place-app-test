//
//  ErrorHandler.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 01/03/26.
//

import Combine
import SwiftUI

final class ErrorHandler: ObservableObject {
    @Published private(set) var currentError: Error?
    
    func handle(_ error: Error) {
        currentError = error
    }
    
    func resetState() {
        currentError = nil
    }
}

extension View {
    func errorAlert(handler: ErrorHandler) -> some View {
        alert(
            "Error",
            isPresented: Binding(
                get: { handler.currentError != nil },
                set: { if !$0 { handler.resetState() } }
            )
        ) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(handler.currentError?.localizedDescription ?? "")
        }
    }
}
