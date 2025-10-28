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
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: { 
                    isAuthenticated = true
                    dismiss()
                }) {
                    Text("Skip")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)

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
