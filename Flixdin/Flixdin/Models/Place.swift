//
//  Location.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/07/23.
//

import Foundation
import SwiftUI
import MapKit

struct Place: Identifiable {
    
    var id = UUID().uuidString
    var place: MKMapItem = MKMapItem()
}
