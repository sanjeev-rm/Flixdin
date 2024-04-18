//
//  ReceiversMessageViewViewModel.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 09/07/23.
//

import Foundation
import SwiftUI

class ReceiversMessageViewViewModel: ObservableObject {
    
    @Published var receiverMessage: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Rhoncus aenean vel elit scelerisque mauris pellentesque pulvinar pellentesque."]
    @Published var receiverImage: Image = Image(systemName: "person.fill")
    
}
