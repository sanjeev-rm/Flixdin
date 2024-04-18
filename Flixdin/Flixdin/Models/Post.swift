//
//  Post.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 09/08/23.
//

import Foundation
import SwiftUI

struct Post: Codable {
    
    var postid: String
    var ownerid: String
    var domain: String
    var caption: String
    var applicants: [String]
    var location: String
    var likes: [String]
    var image: String
    var time_of_post: String
    
    enum CodingKeys: String, CodingKey {
        case postid
        case ownerid
        case domain
        case caption
        case applicants
        case location
        case likes
        case image
        case time_of_post
    }
}

let SAMPLE_POST = Post(postid: "post.zW5DChx5SlcdYHMO5h5mc7joiU42.2024-03-04T05:39:48Z",
                       ownerid: "zW5DChx5SlcdYHMO5h5mc7joiU42",
                       domain: "Actor",
                       caption: "Lost in the vast symphony of existence, every 'Oh.' is a note that resonates with the unpredictable melody of life. 🎵✨ Join me in this grand performance, where spontaneity dances with the rhythm of the universe. 🌌🕺 #EmbraceTheOh #EpicJourney",
                       applicants: [],
                       location: "Earth",
                       likes: ["zW5DChx5SlcdYHMO5h5mc7joiU42"],
                       image: "https://minio.flixdin.com/test/postImage/post.zW5DChx5SlcdYHMO5h5mc7joiU42.2024-03-04T05:39:48Z",
                       time_of_post: "2024-03-04T11:09:49.292Z")
