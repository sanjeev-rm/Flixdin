//
//  FlixImage.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/07/23.
//

import Foundation
import SwiftUI

/// Contains Images related to Flix App.
enum FlixImage: String {
    case logo = "flix.image.logo"
    case sliderThumb = "flix.image.slider.thumb"
    case defaultProfilePicture = "flix.image.profilePicture.default"
    case otherSkillsLogo = "flix.image.otherSkills"
    case grid = "flix.image.grid"
    case connectionCall = "flix.image.connectionCallLogo"
    case portfolio = "flix.image.portfolio"
    case tagged = "flix.image.personTagged"
    case saved = "flix.image.bookmark"
}

/// Extension of Image and creating a new custom initialiser for Image
extension Image {
    /// Custom initialiser for Image
    /// With FlixImage
    init(flixImage: FlixImage) {
        self.init(flixImage.rawValue)
    }
}



extension UIImage {
    convenience init?(flixImage: FlixImage) {
        self.init(named: flixImage.rawValue)
    }
}
