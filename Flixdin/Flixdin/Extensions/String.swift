//
//  String.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 29/09/23.
//

import Foundation
import SwiftUI

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
