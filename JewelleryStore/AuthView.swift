//
//  AuthView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct AuthView: View {
    @Binding var isAuthenticated: Bool
    @State private var username = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text(isSignUp ? "Sign Up" : "Log In")
                .font(.largeTitle)
                .padding()
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Button(isSignUp ? "Create Account" : "Log In") {
                authenticate()
            }
            .padding()
            Button(isSignUp ? "Already have an account? Log In" : "No account? Sign Up") {
                isSignUp.toggle()
                errorMessage = ""
            }
            .padding()
        }
        .padding()
    }

    func authenticate() {
        errorMessage = ""
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both username and password."
            return
        }
        if isSignUp {
            NetworkManager.shared.signup(username: username, password: password) { result in
                DispatchQueue.main.async {
                    handleAuthResult(result)
                }
            }
        } else {
            NetworkManager.shared.login(username: username, password: password) { result in
                DispatchQueue.main.async {
                    handleAuthResult(result)
                }
            }
        }
    }

    private func handleAuthResult(_ result: Result<AuthResponse, Error>) {
        switch result {
        case .success(let response):
            if response.success, let _ = response.token {
                isAuthenticated = true
            } else {
                errorMessage = response.message ?? "Authentication failed."
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}
