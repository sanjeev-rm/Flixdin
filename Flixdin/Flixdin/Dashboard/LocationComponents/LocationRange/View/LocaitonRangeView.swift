//
//  LocaitonRangeView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//

import SwiftUI

struct LocaitonRangeView: View {
    
    @State var distance: Float = 20
    var sliderRange: ClosedRange<Double> = 1...100
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            Rectangle()
                .frame(width: 2 * width / 3, height: 100)
                .foregroundColor(.clear)
                .background(Color(flixColor: .backgroundSecondary))
                .cornerRadius(8)
            VStack (alignment: .leading, spacing: 8) {
                Text("Distance")
                    .font(.system(size: 12))
                    .padding([.leading, .top], 8)
                Text("Upto \(Int(distance)) Kilometeres")
                    .padding(.leading, 8)
                    .font(.system(size: 12))
                Slider(value: $distance, in: 0...100)
                    .frame(width:  2 * width / 3 - 20)
                    .padding(.leading, 10)
            }
        }
    }
}

struct LocaitonRangeView_Previews: PreviewProvider {
    static var previews: some View {
        LocaitonRangeView()
    }
}
