//
//  NotificationsContainerView.swift
//  flixdinapp
//
//  Created by Shashwat Singh on 8/7/23.
//


import SwiftUI

struct NotificationsView : View {
    
    @Environment(\.dismiss) var dismiss
    
    enum NotificationsCategory: String, CaseIterable {
        case all = "All"
        case posts = "Posts"
        case connectionCalls = "Connection Calls"
    }
    
    @State var notificationsType: NotificationsCategory = .all

   
   
    var body: some View {
        
        NavigationView {
            VStack(spacing: 24) {
                notificationTypePicker
                
                ScrollView {
                    VStack {
                        ForEach(SAMPLE_NOTIFICATIONS, id: \.user.fullName) { notification in
                            NewNotificationCardView(notification: notification)
                                .padding()
//                                .background(Color(flixColor: .backgroundSecondary))
//                                .cornerRadius(16)
//                                .padding(.horizontal)
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.top,16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("Notifications")
                        .foregroundColor(.accentColor)
                        .font(.title)
                        .bold()
                }
            }
            .onAppear {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(flixColor: .backgroundSecondary))
                UISegmentedControl.appearance().backgroundColor = .clear
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.secondaryLabel], for: .normal)
                
//                    updateContent(contentType: contentType)
            }
        }
    }
}

extension NotificationsView{
    
    private var notificationTypePicker : some View {
        Picker("Connection calls created or applied or saved?", selection: $notificationsType) {
            ForEach(NotificationsCategory.allCases, id: \.self) { category in
                Text(category.rawValue).tag(category)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}


struct NotificationsContainerView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
