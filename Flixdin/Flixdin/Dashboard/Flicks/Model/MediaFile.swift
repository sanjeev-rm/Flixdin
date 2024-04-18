//
//  MediaFile.swift
//  Flixdin
//
//  Created by Sanjeev RM on 28/08/23.
//

import Foundation
import SwiftUI

struct MediaFile: Identifiable {
    var id = UUID().uuidString
    var url: String
    var title: String
    var description: String = sampleDescription
    var isExpanded: Bool = false
}

var MediaFileJSON = [
    MediaFile(url: "flick1", title: "Apple.."),
    MediaFile(url: "flick2", title: "Get and go.."),
    MediaFile(url: "flick3", title: "Okay now."),
    MediaFile(url: "flick4", title: "My new car.."),
    MediaFile(url: "flick5", title: "Bought my ma a new home.."),
    MediaFile(url: "flick6", title: "MoNoChRoMe..")
]

var sampleDescription: String = "The fifty mannequin heads floating in the pool kind of freaked them out. Flesh-colored yoga pants were far worse than even he feared.\n\nThe sign said there was road work ahead so he decided to speed up. She could hear him in the shower singing with a joy she hoped he'd retain after she delivered the news. He was surprised that his immense laziness was inspirational to others."
