//
//  SearchedUserModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 03/06/2024.
//

import Foundation


struct SearchUserRequest: Encodable{
    let query: String
}

struct SearchedUserResponse: Codable, Identifiable {
    var id: String
    var fullname: String
    var username: String
    var profilepic: String?
}

