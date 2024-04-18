//
//  SaveButton.swift
//  Flixdin
//
//  Created by Sanjeev RM on 29/01/24.
//

import SwiftUI

struct SaveButton: View {
    
    @State var saved: Bool = false
    
    var save: (() -> Void) = {print("DEBUG: Saved!")}
    var unSave: (() -> Void) = {print("DEBUG: Unsaved")}
    
    var body: some View {
        Button {
            if saved {
                unSave()
            } else {
                save()
            }
            saved.toggle()
        } label: {
            Image(systemName: saved ? "bookmark.fill" : "bookmark")
        }
        .font(.title3)
    }
}

#Preview {
    SaveButton()
}
