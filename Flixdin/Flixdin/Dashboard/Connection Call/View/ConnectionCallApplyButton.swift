//
//  ConnectionCallApplyButton.swift
//  Flixdin
//
//  Created by Sanjeev RM on 29/01/24.
//

import SwiftUI

struct ConnectionCallApplyButton: View {
    
    @State var applied: Bool = false
    
    var applyAction: (() -> Void)
    var removeApplicationAction: (() -> Void)
    
    var body: some View {
        Button {
            if applied {
                removeApplicationAction()
            } else {
                applyAction()
            }
            applied.toggle()
        } label: {
            Text(applied ? "Applied!" : "Apply")
                .font(.callout)
                .fontWeight(.semibold)
        }
        .buttonStyle(.borderedProminent)
        .tint(applied ? .green.opacity(0.3) : .accentColor)
    }
}

#Preview {
    ConnectionCallApplyButton {
        print("DEBUG: Applied!")
    } removeApplicationAction: {
        print("DEBUG: Application removed")
    }

}
