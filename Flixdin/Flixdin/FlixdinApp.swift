//
//  FlixdinApp.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/07/23.
//

import SwiftUI
import Firebase

@main
struct FlixdinApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if authenticationViewModel.temporaryIsLoggedIn || (authenticationViewModel.isLoggedIn ?? false) {
                    DashboardView()
                        .environmentObject(authenticationViewModel)
                } else {
                    AuthenticationView()
                        .environmentObject(authenticationViewModel)
                }
            }
        }
    }
}
