//
//  FlixdinButton.swift
//  Flixdin
//
//  Created by Sanjeev RM on 07/06/24.
//

import SwiftUI

struct FlixdinButton: View {
    
    var labelText: String
    var showProgress: Bool = false
    var action: () -> Void
    
    var body: some View {
        ZStack {
            if showProgress {
                Button {
                    // No action
                } label: {
                    ProgressView()
                        .dynamicTypeSize(.xxxLarge)
                        .font(.title2)
                        .fontWeight(.bold)
                        .tint(Color(flixColor: .darkOlive))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(.accent)
                        .cornerRadius(8)
                }
            } else {
                Button {
                    action()
                } label: {
                    Text(labelText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(flixColor: .darkOlive))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .background(.accent)
                        .cornerRadius(8)
                }
            }
        }
    }
}

#Preview {
    VStack {
        FlixdinButton(labelText: "Label", action: {
            print("DEBUG: Flixdin Button Tapped")
        })
        
        FlixdinButton(labelText: "Label", showProgress: true, action: {
            print("DEBUG: Flixdin Button Tapped")
        })
    }
    .padding()
}
