//
//  Flick.swift
//  Flixdin
//
//  Created by Sanjeev RM on 26/08/23.
//

import Foundation
import SwiftUI
import AVKit

struct Flick: Identifiable {
    var id = UUID().uuidString
    var player: AVPlayer?
    var mediaFile: MediaFile
}


struct FlickRequest: Encodable{
    let id: String
    let file: String
}
