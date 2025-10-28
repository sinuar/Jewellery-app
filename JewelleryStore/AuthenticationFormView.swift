//
//  AuthenticationFormView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 09/10/25.
//

import SwiftUI

struct AuthenticationFormView: View {
    @Binding var isAuthenticated: Bool
    var isSignUp: Bool
    var onToggleAuthMode: () -> Void = {}
    @AppStorage("userEmail") private var userEmail: String = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Logo / Branding
                VStack(spacing: 12) {
                    Image("diamond-necklace")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                    Text("My Jewellery Store")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top, 24)

                Text(isSignUp ? "Sign Up" : "Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Form fields
                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                Button(isSignUp ? "Create Account" : "Sign In") {
                    authenticate()
                }
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor.opacity(0.9))
                .foregroundColor(.white)
                .cornerRadius(14)
                .padding(.horizontal)

                // Toggle between Sign In / Sign Up
                HStack(spacing: 4) {
                    Text(isSignUp ? "Already have an account?" : "Don't have an account?")
                        .foregroundColor(.secondary)
                    Button(action: onToggleAuthMode) {
                        Text(isSignUp ? "Sign In" : "Sign Up")
                            .fontWeight(.semibold)
                    }
                }
                .font(.footnote)

                Spacer(minLength: 20)
            }
        }
        .padding(.top, 8)
    }
    
    func authenticate() {
        errorMessage = ""
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password."
            return
        }
        if isSignUp {
            NetworkManager.shared.signup(username: email, password: password) { result in
                DispatchQueue.main.async {
                    handleAuthenticationResult(result)
                }
            }
        } else {
            NetworkManager.shared.login(username: email, password: password) { result in
                DispatchQueue.main.async {
                    handleAuthenticationResult(result)
                }
            }
        }
    }
    
    private func handleAuthenticationResult(_ result: Result<AuthenticationResponse, Error>) {
        switch result {
        case .success(let response):
            if response.success, let _ = response.token {
                userEmail = email
                isAuthenticated = true
            } else {
                errorMessage = response.message ?? "Authentication failed."
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}
