//
//  AlertSheetView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 19/09/23.
//

import SwiftUI

struct AlertSheetView: View {
    
    var imageSystemName: String = "wifi.slash"
    var imageForegroundColor: Color = Color(.secondaryLabel)
    var alertMessage: String = "And error occured, try again"
    
    @Binding var showAlert: Bool
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: imageSystemName)
                .font(.largeTitle)
                .foregroundColor(imageForegroundColor)
            Text(alertMessage)
                .multilineTextAlignment(.center)
                .font(.callout)
                .foregroundColor(Color(.secondaryLabel))
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                showAlert = false
            }
        }
    }
}

struct AlertSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AlertSheetView(showAlert: .constant(true))
    }
}
