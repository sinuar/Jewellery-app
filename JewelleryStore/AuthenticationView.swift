//
//  AuthenticationView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct AuthenticationView: View {
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
                VStack(spacing: 16) {
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
                .padding(.bottom, 16)
            }
        }
        .sheet(isPresented: $showLoginSheet) {
            AuthenticationFormView(isAuthenticated: $isAuthenticated, isSignUp: false)
        }
        .sheet(isPresented: $showRegisterSheet) {
            AuthenticationFormView(isAuthenticated: $isAuthenticated, isSignUp: true)
        }
    }
}
