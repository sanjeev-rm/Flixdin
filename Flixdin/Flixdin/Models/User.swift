//
//  User.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/07/23.
//

import Foundation
import SwiftUI

struct User: Identifiable, Codable {
    
    var id: String = ""
    var fullName: String = ""
    var username: String = ""
    var mobileNo: String = ""
    var mailID: String = ""
    var password: String = ""
    var birthday: String = ""
    var domain: String = ""
    var otherSkills: [String] = []
    var followers: [String] = []
    var following: [String] = []
    var connectionCall: [String] = []
    var savedposts: [String] = []
    var savedConnectionCalls: [String] = []
    var appliedConnectionCalls: [String] = []
    var savedReels: [String] = []
    var profilePic: String?
    var sex: String = "\(Gender.preferNotToSay.rawValue)"
    var bio: String = ""
    
    var displayProfilePic: Image {
        if let profilePicURL = profilePic, let url = URL(string: profilePicURL),
           let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.fill")
        }
    }
    
    init(id: String = "", fullName: String = "", username: String = "", mobileNo: String = "", mailID: String = "", password: String = "", birthday: String = "", domain: String = "", otherSkills: [String] = [], followers: [String] = [], following: [String] = [], connectionCall: [String] = [], savedposts: [String] = [], savedConnectionCalls: [String] = [], appliedConnectionCalls: [String] = [], savedReels: [String] = [], profilePic: String? = nil, sex: String = "", bio: String = "") {
        self.id = id
        self.fullName = fullName
        self.username = username
        self.mobileNo = mobileNo
        self.mailID = mailID
        self.password = password
        self.birthday = birthday
        self.domain = domain
        self.otherSkills = otherSkills
        self.followers = followers
        self.following = following
        self.connectionCall = connectionCall
        self.savedposts = savedposts
        self.savedConnectionCalls = savedConnectionCalls
        self.appliedConnectionCalls = appliedConnectionCalls
        self.savedReels = savedReels
        self.profilePic = profilePic
        self.sex = sex
        self.bio = bio
    }
    
    init(responseBody: ProfileAPIService.GetUserResponseBody) {
        self.id = responseBody.id
        self.fullName = responseBody.fullname
        self.username = responseBody.username
        self.mobileNo = responseBody.mobileno
        self.mailID = responseBody.mailid
        self.password = ""
        self.birthday = responseBody.birthday ?? ""
        self.domain = responseBody.domain
        self.otherSkills = responseBody.otherskills
        self.followers = responseBody.followers
        self.following = responseBody.following
        self.connectionCall = responseBody.connectioncall ?? []
        self.savedposts = responseBody.savedposts ?? []
        self.savedConnectionCalls = responseBody.savedconnectioncalls ?? []
        self.appliedConnectionCalls = responseBody.appliedconnectioncalls ?? []
        self.savedReels = responseBody.savedreels ?? []
        self.profilePic = responseBody.profilepic
        self.sex = responseBody.sex ?? ""
        self.bio = responseBody.bio ?? ""
    }
    
    static var samples: [User] = [
        User(id: "1", username: "Paris", mobileNo: "1234565787", mailID: "email1@gmail.com", domain: "Actor", otherSkills: ["Animation", "Photography"]),
        User(id: "2", username: "Germany", mobileNo: "1234565787", mailID: "email1@gmail.com", domain: "Director", otherSkills: ["Animation", "Photography"]),
        User(id: "3", username: "India", mobileNo: "1234565787", mailID: "email1@gmail.com", domain: "Choreographer", otherSkills: ["Animation", "Photography"]),
        User(id: "4", username: "Scotland", mobileNo: "1234565787", mailID: "email1@gmail.com", domain: "Musician", otherSkills: ["Animation", "Photography"]),
        User(id: "5", username: "Melbourne", mobileNo: "1234565787", mailID: "email1@gmail.com", domain: "Editor", otherSkills: ["Animation", "Photography"])
    ]
    
}
