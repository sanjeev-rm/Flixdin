//
//  AuthenticationViewModel.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/07/23.
//

import Foundation
import SwiftUI

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    // MARK: - LoggedIn
    
    /// Variable to show wether the user is loggedIn or not
    /// Saving in AppStorage so that it's persistent
    /// When the app is restarted they will be logged in, if this variable is true
    @AppStorage(Storage.Key.isLoggedIn.rawValue) var isLoggedIn: Bool?
    
    /// Variable to make user temporarily loggedIn
    /// When the app is restarted they will be logged out
    @Published var temporaryIsLoggedIn: Bool = false
    
    // MARK: - Others
    
    /// Variable specifies wether to show SignUp View or not
    @Published var showSignUpView: Bool = false
    
    /// Variable specifies wether to show ForgotPassword View or not
    @Published var showForgotPasswordView: Bool = false
    
//    /// Variable specifies whether to show LoginView or not.
//    @Published var showLoginView: Bool = true
    
    func reset() {
        isLoggedIn = false
        temporaryIsLoggedIn = false
        showSignUpView = false
        showForgotPasswordView = false
    }
}
