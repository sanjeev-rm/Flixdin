//
//  ExtensionNSMutableData.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 29/09/23.
//

import Foundation

extension NSMutableData {
    
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
