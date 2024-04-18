//
//  ForgotPasswordViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/07/23.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var navigateToOtp: Bool = false
    
    @Published var otp: String = ""
    @Published var navigateToResetPassword: Bool = false
    
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var showProgress: Bool = false
    
    @Published var showAlert: Bool = false
    
    @Published var errorMessage: String = ""
    
    func resetPassword(email: String) async throws {
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
}
