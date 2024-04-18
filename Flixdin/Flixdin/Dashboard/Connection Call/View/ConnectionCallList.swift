//
//  ConnectionCallList.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/03/24.
//

import SwiftUI

struct ConnectionCallList: View {
    
    @Binding var connectionCalls: [ConnectionCall]
    
    var body: some View {
        ScrollView {
            
            VStack (alignment: .center, spacing: 16){
                
                if connectionCalls.isEmpty {
                    Text("No connection calls")
                        .foregroundStyle(.secondary)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    
                    ForEach(connectionCalls, id: \.postid) { connectionCall in
                        ConnectionCallCardView(connectionCall: connectionCall)
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
        .background(.clear)
    }
}

#Preview {
    ConnectionCallList(connectionCalls: .constant([]))
}
