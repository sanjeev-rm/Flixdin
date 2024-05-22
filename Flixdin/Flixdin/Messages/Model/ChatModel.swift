//
//  ChatModel.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 22/05/2024.
//

import Foundation

struct ChatRequesstBody: Encodable{
    let userId: String
}

struct ChatResponse: Identifiable, Decodable, Hashable{
    let room_id: String
    let latest_message_content: String
    let latest_message_time: String
    let receiver_id: String
    let receiver_name: String
    let receiver_profilepic: String
    let unread_count: Int
    
    var id: String { room_id }
}
