//
//  AuthenticationView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var isAuthenticated: Bool
    @State private var isSignUp: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: { isAuthenticated = true }) {
                    Text("Skip")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)

            // Authentication mode switcher
//            Picker("Authentication Mode", selection: $isSignUp) {
//                Text("Sign In").tag(false)
//                Text("Sign Up").tag(true)
//            }
//            .pickerStyle(.segmented)
//            .padding(.horizontal, 16)
//            .padding(.top, 8)

            // Form content
            AuthenticationFormView(
                isAuthenticated: $isAuthenticated,
                isSignUp: isSignUp
            )
            .padding(.top, 8)

            Spacer(minLength: 0)
        }
    }
}

#Preview {
    AuthenticationView(isAuthenticated: .constant(false))
}
