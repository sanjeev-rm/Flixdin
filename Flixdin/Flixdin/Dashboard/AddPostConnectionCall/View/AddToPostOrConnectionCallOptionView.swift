//
//  AddToPostOrConnectionCallOptionView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/08/23.
//

import SwiftUI

struct AddToPostOrConnectionCallOptionView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            cancelButton
            addPostAndConnectionCallButtons
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
}



extension AddToPostOrConnectionCallOptionView {
    
    private var cancelButton: some View {
        HStack {
            Spacer()
            Button {
                // Dismiss the view
                homeViewModel.showAddPostOrConnectionCallOptions = false
            } label: {
                Image(systemName: "xmark")
            }
        }
    }
    
    private var addPostAndConnectionCallButtons: some View {
        VStack(alignment: .leading) {
            addPostButton
            Divider()
            addConnectionCallButton
        }
        .padding()
        .background(Color(flixColor: .backgroundSecondary))
        .cornerRadius(16)
    }
    
    private var addPostButton: some View {
        Button {
            // Show Add Post
            homeViewModel.showAddPostOrConnectionCallOptions = false
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.01) {
                homeViewModel.showAddPostView = true
            }
        } label: {
            HStack {
                Text("Add Post")
                    .foregroundColor(.primary)
                Spacer()
            }
        }
    }
    
    private var addConnectionCallButton: some View {
        Button {
            // Show Add Connection Call View
            homeViewModel.showAddPostOrConnectionCallOptions = false
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.01) {
                homeViewModel.showAddConnectionCallView = true
            }
        } label: {
            HStack {
                Text("Add Connection Call")
                    .foregroundColor(.primary)
                Spacer()
            }
        }
    }
}

struct AddToPostOrConnectionCallOptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddToPostOrConnectionCallOptionView()
            .environmentObject(HomeViewModel())
    }
}
