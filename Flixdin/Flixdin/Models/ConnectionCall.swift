//
//  ConnectionCall.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/07/23.
//

import Foundation

struct ConnectionCall: Codable {
    
//    var id = UUID()
    
    var postid: String
    var ownerid: String
    var domain: String
    var caption: String
    var applicants: [String]
    var location: String
    var likes: [String]
    var image: String
    var time_of_post: String
    var comments: String
    var fullname: String
    var profilepic: String
    var username: String
    
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
        case comments
        case fullname
        case profilepic
        case username
    }

    
//    static var samples: [ConnectionCall] = [
//        ConnectionCall(user: User.samples[0], needDomain: .animation, location: "Hyderabad", isLiked: false, applicants: User.samples.dropLast(1)),
//        ConnectionCall(user: User.samples[1], needDomain: .animation, location: "Navi Mumbai", isLiked: false, applicants: User.samples.dropLast(3)),
//        ConnectionCall(user: User.samples[3], needDomain: .animation, location: "Chennai", isLiked: false, applicants: User.samples.dropLast(4)),
//        ConnectionCall(user: User.samples[1], needDomain: .animation, location: "Hyderabad", isLiked: false, applicants: User.samples.dropLast(2)),
//        ConnectionCall(user: User.samples[4], needDomain: .animation, location: "Hyderabad", isLiked: false, applicants: User.samples)
//    ]
}

//let CONNECTION_CALL_SAMPLE = ConnectionCall(postid: "", ownerid: "", domain: "Actor", caption: "Need a camera crew", applicants: [], location: "Hyderabad", likes: [], image: "", time_of_post: "", comments: "", fullname: "Paris", profilepic: "", username: "paris")

let CONNECTION_CALL_SAMPLES : [ConnectionCall] = [
//    ConnectionCall(postid: "", ownerid: "", domain: "Actor", caption: "Need a camera crew", applicants: [], location: "Hyderabad", likes: [], image: "", time_of_post: "", comments: "", fullname: "Paris", profilepic: "", username: "paris"),
//    ConnectionCall(postid: "", ownerid: "", domain: "Director", caption: "Looking for efficient budget friendly writers", applicants: [], location: "Chennai", likes: [], image: "", time_of_post: "", comments: "", fullname: "John Doe", profilepic: "", username: "john_doe"),
//    ConnectionCall(postid: "", ownerid: "", domain: "Cinematographer", caption: "Need state of the art camera crew", applicants: [], location: "Hyderabad", likes: [], image: "", time_of_post: "", comments: "", fullname: "John Appleseed", profilepic: "", username: "john_apple"),
//    ConnectionCall(postid: "", ownerid: "", domain: "Actor", caption: "Need directors with over 3 movies released till date", applicants: [], location: "Mumbai", likes: [], image: "", time_of_post: "", comments: "", fullname: "Kevin Hart", profilepic: "", username: "kevin_heart")
]
