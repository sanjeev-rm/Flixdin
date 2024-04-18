//
//  LoginViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/07/23.
//

import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    
    @Published var showErrorMessage: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var showProgress: Bool = false
    
    @Published var showEmailSentAlert: Bool = false
    
    func showEmailPasswordInvalid(message: String = "Invalid email or password") {
        showErrorMessage = true
        errorMessage = message
    }
    
    func presentForgotPasswordEmailSentAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showEmailSentAlert = true
        }
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            print("DEBUG: No email or password found.")
            showEmailPasswordInvalid(message: "No email or password found")
            return
        }
        
        showErrorMessage = false
        showProgress = true
        
        Task {
            do {
                try await AuthenticationManager.shared.loginUser(email: email, password: password)
                if let user = try? AuthenticationManager.shared.getAuthenticatedUser() {
                    print("DEBUG: user id - \(user.uid)")
                    Storage.loggedInUserId = user.uid
                    completion(true)
                }
            } catch(let error) {
                print("DEBUG: " + error.localizedDescription)
                showEmailPasswordInvalid(message: "Invalid email or password, try signing up")
                completion(false)
            }
            
            showProgress = false
        }
    }
}
