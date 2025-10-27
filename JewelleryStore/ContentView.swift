//
//  ContentView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false

    var body: some View {
        if isAuthenticated {
            CatalogView()
        } else {
            AuthenticationView(isAuthenticated: $isAuthenticated)
        }
    }
}

#Preview {
    ContentView()
}
