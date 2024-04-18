//
//  HeartBounceView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 14/03/24.
//

import SwiftUI

struct HeartBounceView: View {
    
    @State var size: CGFloat = 1
    @State var foreGroundStyle: Color = .white
    var body: some View {
        Image(systemName: "heart.fill")
            .foregroundStyle(foreGroundStyle)
            .font(.system(size: size))
            .onAppear {
                DispatchQueue.global().asyncAfter(deadline: .now()) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        foreGroundStyle = .white
                        size = 64
                    }
                }
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        size = 1
                        foreGroundStyle = .clear
                    }
                }
            }
    }
}

#Preview {
    HeartBounceView()
}
