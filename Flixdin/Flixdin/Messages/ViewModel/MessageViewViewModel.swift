//
//  MessageViewViewModel.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 09/07/23.
//

import Foundation

class MessageViewViewModel: ObservableObject {
    
    @Published var userName : String = "Username"
    @Published var onlineStatus: Bool = false
    @Published var isTyping: Bool = true
    @Published var message: String = ""
    
}
