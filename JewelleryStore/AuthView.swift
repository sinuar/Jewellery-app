//
//  AuthView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct AuthView: View {
    @Binding var isAuthenticated: Bool
    @State private var showLoginSheet = false
    @State private var showRegisterSheet = false

    var body: some View {
        ZStack {
            // Replace "jewellery_bg" with your image asset name
            Image("diamond-necklace")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                VStack(spacing: 24) {
                    Button(action: { showLoginSheet = true }) {
                        Text("Log In")
                            .font(.title)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(Color.white.opacity(0.85))
                            .foregroundColor(.black)
                            .cornerRadius(32)
                    }
                    Button(action: { showRegisterSheet = true }) {
                        Text("Register")
                            .font(.title)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(Color.white.opacity(0.85))
                            .foregroundColor(.black)
                            .cornerRadius(32)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
        .sheet(isPresented: $showLoginSheet) {
            AuthFormView(isAuthenticated: $isAuthenticated, isSignUp: false)
        }
        .sheet(isPresented: $showRegisterSheet) {
            AuthFormView(isAuthenticated: $isAuthenticated, isSignUp: true)
        }
    }

    // ...existing code...
    // Authentication logic moved to AuthFormView
}
