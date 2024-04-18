//
//  AddConnectionCallView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/08/23.
//

import SwiftUI

struct AddConnectionCallView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var newConnectionCallViewModel = NewConnectionCallViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 32) {
                titleAndCancelButton
                if newConnectionCallViewModel.connectionCallPosted {
                    PostedView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(.easeOut) {
                                    self.dismiss()
                                }
                            }
                        }
                } else {
                    ScrollView {
                        newConnectionCallAndAddButton
                            .scrollDismissesKeyboard(.interactively)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
            .onAppear {
                UtilityFunction.getCurrentUser { user in
                    guard let user = user else { return }
                    DispatchQueue.main.async {
                        self.newConnectionCallViewModel.currentUser = user
                    }
                }
            }
        }
    }
}



extension AddConnectionCallView {
    
    private var titleAndCancelButton: some View {
        VStack(spacing: 18) {
            Rectangle()
                .frame(height: 0.6)
                .foregroundColor(Color.accentColor)
            HStack {
                Text("New Connection Call")
                    .font(.title2)
                    .foregroundColor(Color.accentColor)
                Spacer()
                Button {
                    // Dismiss view
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .dynamicTypeSize(.xxxLarge)
                }
            }
            .padding(.horizontal, 16)
            Rectangle()
                .frame(height: 0.6)
                .foregroundColor(Color.accentColor)
        }
    }
    
    private var addButton: some View {
        Button {
            // Adds the connection call
            newConnectionCallViewModel.createNewConnectionCall { success in
                if success {
                    print("DEBUG: Success")
                    // Show the done view and dismiss the newConnectionCallView
                } else {
                    print("DEUBG: Error")
                }
            }
        } label: {
            HStack {
                Spacer()
                ZStack {
                    if newConnectionCallViewModel.showCreatingProgress {
                        ProgressView()
                            .dynamicTypeSize(.xxxLarge)
                    } else {
                        Text("Add")
                    }
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(flixColor: .darkOlive))
                Spacer()
            }
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .disabled(!newConnectionCallViewModel.isAllAvailable())
    }
    
    private var newConnectionCallAndAddButton: some View {
        VStack {
            
            NewConnectionCallCardView()
                .environmentObject(newConnectionCallViewModel)
                .frame(height: UIScreen.main.bounds.height - 300)
            addButton
        }
    }
}

struct AddConnectionCallView_Previews: PreviewProvider {
    static var previews: some View {
        AddConnectionCallView()
    }
}
