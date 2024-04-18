//
//  ConnectionCallView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/07/23.
//

import SwiftUI

struct ConnectionCallView: View {
    
    @ObservedObject var locationVM = LocationChangeViewViewModel.shared
    @ObservedObject var connectionCallVM = ConnectionCallViewModel()
    
    var isShowingView: Bool {
        return locationVM.isShowingLocationRangeView || locationVM.isShowingDomainView || locationVM.isShowingLocationView
    }

    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading){
                
                titleAndNewButton
                    .padding(.horizontal)
                
                LocationChangeView()
                    .redacted(reason: connectionCallVM.isRefreshing ? .placeholder : [])
                    .padding(.horizontal)
                
                connectionCalls
                    .task {
                        connectionCallVM.getConnectionCalls()
                    }
                    .redacted(reason: connectionCallVM.isRefreshing ? .placeholder : [])
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
            .fullScreenCover(isPresented: $connectionCallVM.showNewConnectionCallView,
                             onDismiss: { connectionCallVM.getConnectionCalls() },
                             content: {
                AddConnectionCallView()
            })
        }
    }
}

extension ConnectionCallView {
    
    private var titleAndNewButton: some View {
        HStack {
            Text("Connection Call")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(flixColor: .lightOlive))
            
            Spacer()
            
            Button {
                // Show Add View
                connectionCallVM.showNewConnectionCallView = true
            } label: {
                Image(systemName: "plus.app")
                    .font(.title2)
            }
            .redacted(reason: connectionCallVM.isRefreshing ? .placeholder : [])
        }
    }
    
    private var connectionCalls: some View {
        ConnectionCallList(connectionCalls: $connectionCallVM.connectionCalls)
            .refreshable {
                connectionCallVM.getConnectionCalls()
                print("DEBUG: Reload connection calls")
            }
    }
}

struct ConnectionCallView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionCallView()
    }
}
