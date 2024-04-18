//
//  AuthenticationAPIService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 22/09/23.
//

import Foundation

class AuthenticationAPIService {
    
    /// Errors related to Authentication
    enum AuthError: Error {
        case userAlreadyExists
        case custom(message: String)
    }
    
    /// URL (String) used to create a user
    final var CREATE_USER_URL = "https://api.flixdin.com/insert-user"
    
    /// URL(String) used to post the Profile Picture.
    final var POST_USER_PROFILE_PIC = "https://api.flixdin.com/insert-pp"
}
