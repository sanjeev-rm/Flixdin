//
//  PostedView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 03/03/24.
//

import SwiftUI

struct PostedView: View {
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(flixColor: .lightOlive))
                .font(.system(size: 120))
            Text("Posted!")
                .font(.largeTitle.bold().monospaced())
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    PostedView()
}
