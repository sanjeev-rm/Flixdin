//
//  Clicks.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 12/07/23.
//

import Foundation
import SwiftUI

// Number of Clicks for each User.
struct ClicksBundle : Identifiable {
    let id = UUID().uuidString
    var user: User
    var isSeen: Bool = false
    var clicks: [Clicks]
}

struct Clicks: Identifiable {
    var id = UUID().uuidString
    var ClickImage: AsyncImage<Image>
}
