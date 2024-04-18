//
//  ImageService.swift
//  Flixdin
//
//  Created by Sanjeev RM on 30/10/23.
//

import Foundation
import SwiftUI

extension UIImage {
    
    static func getUIImageFromURL(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print("DEBUG: \(error.debugDescription) - extension.Image from URL")
                completion(nil)
                return
            }

            guard let data = data else {
                print("DEBUG: No data found for image - extension.Image from URL")
                completion(nil)
                return
            }

            guard let loadedImage = UIImage(data: data) else { return }
            completion(loadedImage)
        }.resume()
    }
}
