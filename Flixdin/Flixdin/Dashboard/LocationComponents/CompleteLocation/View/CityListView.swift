//
//  ListView.swift
//  FlixDinApp
//
//  Created by shikhar on 05/07/23.
//

import SwiftUI

let indianCities = [ "Surat", "Pune", "Jaipur", "Lucknow", "Kanpur", "Nagpur", "Indore", "Thane", "Bhopal", "Visakhapatnam", "Pimpri-Chinchwad", "Patna", "Vadodara", "Ludhiana", "Agra", "Nashik", "Faridabad", "Meerut", "Rajkot", "Varanasi", "Srinagar", "Aurangabad", "Dhanbad", "Amritsar", "Navi Mumbai", "Allahabad", "Ranchi", "Howrah", "Coimbatore", "Jabalpur", "Gwalior", "Vijayawada", "Jodhpur", "Madurai", "Raipur", "Kota", "Guwahati", "Solapur", "Bareilly" ]

struct CityListView: View {
    
    
    @State private var isSelected: [Bool] = Array(repeating: false, count: indianCities.count)
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            
            CityHeaderView
            
            MainCityView
            
        }
        .padding()
        .background(
            Rectangle()
                .foregroundColor(.clear)
                .background(Color(flixColor: .backgroundSecondary))
                .cornerRadius(8)
        )
    }
}

extension CityListView{
    
    private var CityHeaderView: some View {
        VStack{
            Text("Select City")
                .font(.system(size: 16))
                .foregroundColor(.primary)
            Divider()
                .frame(width: UIScreen.main.bounds.width - 75, height: 2)
                .background(Color(flixColor: .olive))
        }
    }
    
    private var MainCityView: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack{
                
                ZStack {
                    
                    VStack (alignment: .leading, spacing: 10){
                        ForEach(indianCities.indices, id: \.self) {city in
                            HStack {
                                Button() {
                                    self.selectButton(at: city)
                                } label: {
                                    Text(indianCities[city])
                                        .foregroundColor(Color.primary)
                                }
                                
                                Spacer()
                                
                                if self.isSelected[city] {
                                    Image(systemName: "record.circle")
                                        .padding(.trailing, 20)
                                        .foregroundColor(Color.primary)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
        }
        
    }
    
    func selectButton(at index: Int) {
        isSelected.indices.forEach { buttonIndex in
            isSelected[buttonIndex] = buttonIndex == index
        }
    }
    
}


struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView()
    }
}
