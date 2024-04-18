//
//  SearchPlaceView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 07/04/24.
//

import SwiftUI
import MapKit

struct SearchPlaceView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var searchText: String = ""
    @State var places: [Place] = []
    @Binding var selectedPlace: Place
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Divider()
                searchBar
                Divider()
                
                ScrollView {
                    resultPlacesList
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .navigationTitle("Choose a location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .onChange(of: searchText, perform: { _ in
            searchQuery()
        })
        .scrollDismissesKeyboard(.interactively)
    }
}

extension SearchPlaceView {
    
    func searchQuery() {
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        MKLocalSearch(request: request).start { response, error in
            
            guard let response = response else { return }
            
            self.places = response.mapItems.compactMap({ item in
                return Place(place: item)
            })
        }
    }
}

extension SearchPlaceView {
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.callout)
                .foregroundStyle(.tertiary)
            TextField("Search place", text: $searchText)
        }
        .padding(.vertical, 4)
    }
    
    private var resultPlacesList: some View {
        VStack {
            ForEach(places) { place in
                VStack {
                    Button {
                        selectedPlace = place
                        dismiss()
                    } label: {
                        VStack(alignment: .leading) {
                            Text(place.place.placemark.name!)
                                .fontWeight(.medium)
                            Text(place.place.placemark.country!)
                                .foregroundStyle(.secondary)
                                .font(.callout)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundColor(.primary)
                    Divider()
                }
            }
        }
        .padding([.top, .horizontal])
    }
}

#Preview {
    SearchPlaceView(selectedPlace: .constant(Place()))
}
