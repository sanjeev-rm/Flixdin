//
//  NewNotificationCardView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 14/03/24.
//

import SwiftUI

struct NewNotificationCardView: View {
    
    var notification: Notification
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://picsum.photos/55/55"))
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .frame(width: 55, height: 55)
            
            VStack(alignment: .leading) {
                Text(notification.user.fullName)
                    .font(.headline)
                Text(notification.notificationType.description)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                Text("3 days ago")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            AsyncImage(url: URL(string: ""))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .frame(width: 35, height: 35)
        }
    }
}

#Preview {
    NewNotificationCardView(notification: SAMPLE_NOTIFICATIONS[0])
}
