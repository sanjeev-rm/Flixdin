//
//  TopCityView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 02/08/23.
//

import SwiftUI

struct TopCityView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private let cities = [["Banglore", "Hyderabad", "Mumbai", "Chennai"],
                          ["Delhi-NCR", "Ahmedabad", "Chandigarh", "Kolkata"],
                          ["Srinagar", "Goa", "Pune", "Kochi"]]
    var body: some View {
        citiesView
    }
}

extension TopCityView {
    private var citiesView: some View {
        VStack (spacing: 24){
            ForEach(cities, id: \.self) { cityArray in
                HStack {
                    ForEach(cityArray, id: \.self) { singleCity in
                        Spacer()
                        Button {
                            // Action
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            VStack (spacing: 8){
                                Image(systemName: "globe.asia.australia.fill")
                                    .font(.system(size: 48))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                                Text(singleCity)
                                    .font(.system(.caption2))
                            }
                        }
                        .foregroundColor(.primary)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(
            Rectangle()
                .foregroundColor(Color(flixColor: .backgroundSecondary))
                .cornerRadius(8)
        )
    }
}

struct TopCityView_Previews: PreviewProvider {
    static var previews: some View {
        TopCityView()
    }
}
