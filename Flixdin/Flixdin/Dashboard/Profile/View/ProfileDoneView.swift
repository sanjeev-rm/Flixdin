//
//  ProfileDoneView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 07/07/23.
//

import SwiftUI

struct ProfileDoneView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: width - 30, height: 50)
                    .cornerRadius(8)
                Text("Done")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(10)
            }
        }
    }
}

struct ProfileDoneView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDoneView()
    }
}
