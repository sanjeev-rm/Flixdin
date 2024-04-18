//
//  VerificationPageView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 07/07/23.
//

import SwiftUI

struct VerificationPageView: View {
    var body: some View {
        VStack{
            Text("Verification Page")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(flixColor: .olive))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
}

struct VerificationPageView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationPageView()
    }
}
