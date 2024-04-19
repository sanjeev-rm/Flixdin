//
//  Flick.swift
//  Flixdin
//
//  Created by Sanjeev RM on 26/08/23.
//

import AVKit
import Foundation
import SwiftUI

struct Flick: Identifiable {
    var id = UUID().uuidString
    var player: AVPlayer?
    var mediaFile: MediaFile
}

struct FlickRequest: Encodable {
    let id: String
    let file: String
}

// MARK: NewFlixRequest

struct NewFlixRequest: Encodable {
    let ownerid: Int
    let domain: String
    let caption: String
    let applicants: Int
    let location: String
    let likes: [String]
    let flixurl: String
    let flixdate: String
    let comments: [String]
}

// MARK: DeleteFlixRequest

struct DeleteFlixRequest: Encodable {
    let flixid: Int
}

// MARK: UpdateFlixRequest

struct UpdateFlixRequest: Encodable {
    let flixid: Int
    let fieldname: String
    let value: String
}

// MARK: LikeOrDislikeFlixRequest

struct LikeOrDislikeFlixRequest: Encodable {
    let flixid: Int
    let userid: Int
}

// MARK: APIResponse

struct APIResponse: Decodable {
    let message: String
}
