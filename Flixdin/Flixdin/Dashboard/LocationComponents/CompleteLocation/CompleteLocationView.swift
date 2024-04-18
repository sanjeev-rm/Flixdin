//
//  CompleteLocationView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 04/08/23.
//

import SwiftUI

struct CompleteLocationView: View {
    var body: some View {
        VStack {
            
//            SearchFieldView(backgroundColor: Color(flixColor: .backgroundSecondary))
            
            TopCityView()
            
            CityListView()
        }
        .padding()
    }
}

struct CompleteLocationView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteLocationView()
    }
}
