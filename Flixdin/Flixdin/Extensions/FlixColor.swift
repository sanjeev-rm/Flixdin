//
//  FlixColor.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/07/23.
//

import Foundation
import SwiftUI

/// FlixColor Enum.
/// The custom colors for the app
/// rawValue contains the color of the image
enum FlixColor: String {
    case backgroundPrimary = "flix.color.background.primary"
    case backgroundSecondary = "flix.color.background.secondary"
    case backgroundTernary = "flix.color.background.ternary"
    case black = "flix.color.black"
    case lightBlack = "flix.color.blackLight"
    case olive = "flix.color.olive"
    case lightOlive = "flix.color.oliveLight"
    case darkOlive = "flix.color.oliveDark"
    case textFieldBorderPrimary = "flix.color.textField.border.primary"
    case textFieldBorderSecondary = "flix.color.textField.border.secondary"
    case tabButtonDefault = "flix.color.tabButton.default"
    case tabButtonSelected = "flix.color.tabButton.selected"
    case notifDefault = "flix.color.notification.default"
    case notifSelected = "flix.color.notification.selected"
}

/// Extension of Color and creating a new custom initialiser for Color
extension Color {
    /// Custom initialiser for Color
    /// With FlixColor
    init(flixColor: FlixColor) {
        self.init(flixColor.rawValue)
    }
}
