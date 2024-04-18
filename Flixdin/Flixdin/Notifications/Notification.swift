//
//  NotificationCardViewModel.swift
//  Flixdin
//
//  Created by Shashwat Singh on 7/7/23.
//

import Foundation
import SwiftUI

enum NotificationType: String {
    case likedPost
    case likedConnectionCall
    case applied
    
    var description: String {
        switch self {
        case .likedPost:
            return "liked your post"
        case .likedConnectionCall:
            return "liked your connection call"
        case .applied:
            return "applied to your connection call"
        }
    }
}

struct Notification {
    var user: User
    var notificationType: NotificationType
    var postOrConnectionCallId: String
    var date: Date
    
    init(user: User = User(), notificationType: NotificationType = .likedPost, postOrConnectionCallId: String = "", date: Date = .now) {
        self.user = user
        self.notificationType = notificationType
        self.postOrConnectionCallId = postOrConnectionCallId
        self.date = date
    }
}

let SAMPLE_NOTIFICATIONS = [
    Notification(user: User(fullName: "John appleseed"), notificationType: .likedPost, postOrConnectionCallId: "", date: .now),
    Notification(user: User(fullName: "Tom d'cruize"), notificationType: .applied, postOrConnectionCallId: "", date: .now),
    Notification(user: User(fullName: "Paris"), notificationType: .applied, postOrConnectionCallId: "", date: .now),
    Notification(user: User(fullName: "John wick"), notificationType: .likedConnectionCall, postOrConnectionCallId: "", date: .now),
    Notification(user: User(fullName: "Patrick"), notificationType: .likedConnectionCall, postOrConnectionCallId: "", date: .now)
]
