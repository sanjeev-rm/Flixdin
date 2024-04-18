//
//  AuthenticationManager.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 17/09/23.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init(){ }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResult{
        
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResult(user: authDataResult.user)
        
    }
    
    @discardableResult
    func loginUser(email: String, password: String) async throws -> AuthDataResult {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResult(user: authDataResult.user)
    }
    
    func sendEmailVerification() throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        user.sendEmailVerification { error in
            if let error = error {
                print("Error sending the verification Email : \(error.localizedDescription)")
            } else {
                print("Verification Email Sent.")
            }
        }
    }
    
    func checkEmailVerification() throws -> Bool {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        if user.isEmailVerified {
            return true
        }
        
        return false
    }
    
    func getAuthenticatedUser() throws -> AuthDataResult {
        
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }

        return AuthDataResult(user: user)
        
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func logout() throws {
        
        try Auth.auth().signOut()
        
    }

    
}
