//
//  ProfileConnectionCallView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/03/24.
//

import SwiftUI

struct ProfileConnectionCallView: View {
    
    @Binding var user: User
    
    enum ConnectionCallType: String, CaseIterable {
        case created = "Created"
        case applied = "Applied"
        case saved = "Saved"
    }
    @State private var contentType: ConnectionCallType = .created
    @State private var content: [ConnectionCall] = []
    
    var showSegmentedControl: Bool = true
    
    var body: some View {
        if #available(iOS 17.0, *) {
            baseView
                .onChange(of: contentType) { oldValue, newValue in
                    updateContent(contentType: newValue)
                }
        } else {
            baseView
                .onChange(of: contentType, perform: { value in
                    updateContent(contentType: value)
                })
        }
    }
}

extension ProfileConnectionCallView {
    
    private var baseView: some View {
        VStack {
            if showSegmentedControl {
                Picker("Connection calls created or applied or saved?", selection: $contentType) {
                    ForEach(ConnectionCallType.allCases, id: \.self) { contentType in
                        Text(contentType.rawValue).tag(contentType)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
            }
            
            ConnectionCallList(connectionCalls: $content)
        }
        .onAppear {
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color(flixColor: .backgroundSecondary))
            UISegmentedControl.appearance().backgroundColor = .clear
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.secondaryLabel], for: .normal)
            
            updateContent(contentType: contentType)
        }
    }
    
    private func updateContent(contentType: ConnectionCallType) {
        switch contentType {
        case .created:
            ConnectionCallViewModel.getConnectionCallsCreatedBy(userId: user.id) { connectionCalls in
                content = connectionCalls
            }
        case .applied:
            content = []
        case .saved:
            content = []
        }
    }
}

#Preview {
    ProfileConnectionCallView(user: .constant(User()))
}
