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
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 24) {
            Text(isSignUp ? "Register" : "Log In")
                .font(.largeTitle)
                .padding(.top, 32)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            Button(isSignUp ? "Create Account" : "Log In") {
                authenticate()
            }
            .font(.title2)
            .frame(maxWidth: 300)
            .padding()
            .background(Color.accentColor.opacity(0.85))
            .foregroundColor(.white)
            .cornerRadius(24)
            Spacer()
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
                    handleAuthenticationResult(result)
                }
            }
        } else {
            NetworkManager.shared.login(username: username, password: password) { result in
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
                isAuthenticated = true
                presentationMode.wrappedValue.dismiss()
            } else {
                errorMessage = response.message ?? "Authentication failed."
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}
