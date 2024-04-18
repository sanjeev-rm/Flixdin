//
//  ViewerClicksViewViewModel.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 12/07/23.
//

import Foundation
import SwiftUI

class ViewerClicksViewViewModel: ObservableObject {
    // List of Stories
    @Published var clicks : [ClicksBundle] = [
        
        ClicksBundle(user: User.samples[0], clicks: [Clicks(ClickImage: AsyncImage(url: URL(string: "https://picsum.photos/400/550"))),
                                                    Clicks(ClickImage: AsyncImage(url: URL(string: "https://picsum.photos/400/550"))),
                                                    Clicks(ClickImage: AsyncImage(url: URL(string: "https://picsum.photos/400/550")))]),
        
        ClicksBundle(user: User.samples[1], clicks: [Clicks(ClickImage: AsyncImage(url: URL(string: "https://picsum.photos/400/550"))),
                                                    Clicks(ClickImage: AsyncImage(url: URL(string: "https://picsum.photos/400/550")))])
        
    ]
            
    // decides to show the stories
    @Published var showClick: Bool = false
    // Will be unique for different stories
    @Published var currentClick: String = ""
        
}
