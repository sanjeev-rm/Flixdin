//
//  SenderMessageViewViewModel.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 09/07/23.
//

import Foundation
import SwiftUI

class SenderMessageViewViewModel: ObservableObject {
    
    @Published var senderMessage: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Nibh sed pulvinar proin gravida hendrerit lectus. Non diam phasellus vestibulum lorem sed risus ultricies tristique nulla."]
    @Published var senderImage: Image = Image(systemName: "person.fill")
    @Published var message: String = ""
    
}
