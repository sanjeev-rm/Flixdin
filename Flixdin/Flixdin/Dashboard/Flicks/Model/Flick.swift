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
    let ownerid: String
    let domain: String
    let caption: String
    let applicants: [String]
    let location: String
    let likes: [String]
    let flixurl: String
    let flixdate: String
    let comments: [String]
}

// MARK: NewFlixResponse

struct NewFlixResponse: Decodable {
    let new_flix: String
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

// MARK: GetAllFlixRequest

struct GetAllFlixRequest: Encodable {
    let flixid: String
}

// MARK: GetSpecificFlix

struct GetSpecificFlixRequest: Encodable {
    let flixid: String
}

// MARK: GetSpecificFlixPosterByAUserRequest

struct GetSpecificFlixPosterByAUserRequest: Encodable {
    let userid: String
}

// MARK: Flix Response

struct FlixResponse: Identifiable,Decodable, Hashable{
    let flixid: String
    let ownerid: String
    let domain: String
    let caption: String
    let applicants: [String]
    let location: String
    let likes: [String]
    let flixurl: String
    let flixdate: String
    let comments: [String]
    let banned: Bool
    let embedding: String?
    
    var id: String { flixid }
}

// MARK: APIResponse

struct APIResponse: Decodable {
    let message: String
}
