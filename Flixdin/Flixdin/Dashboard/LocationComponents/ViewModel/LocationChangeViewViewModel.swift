//
//  LocationChangeViewViewModel.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 17/09/23.
//

import Foundation

class LocationChangeViewViewModel: ObservableObject {
    
    static let shared = LocationChangeViewViewModel()
    
    @Published var isShowingLocationRangeView : Bool = false
    @Published var isShowingDomainView : Bool = false
    @Published var isShowingLocationView : Bool = false
    @Published var selectedButton: String = "All"

}
