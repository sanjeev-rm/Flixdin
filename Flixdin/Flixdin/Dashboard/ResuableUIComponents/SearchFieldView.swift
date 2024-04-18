//
//  SearchFieldView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//

import SwiftUI

struct SearchFieldView: View {
    
    var backgroundColor: Color
    
    @Binding var searchQuery : String
    
    var body: some View {
        
            HStack {
                TextField("Search", text: $searchQuery)
                Image(systemName: "magnifyingglass")
            }
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(backgroundColor: Color(flixColor: .backgroundSecondary), searchQuery: .constant(""))
    }
}
