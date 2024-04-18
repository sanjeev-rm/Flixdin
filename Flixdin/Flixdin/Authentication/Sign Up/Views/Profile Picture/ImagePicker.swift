//
//  ImagePicker.swift
//  Flixdin
//
//  Created by Sanjeev RM on 07/07/23.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage
    
    var sourceType: UIImagePickerController.SourceType?
    
    /// This makes the image picker controller and returns it
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        // setting the delegate
        picker.delegate = context.coordinator
        // allows user to crop their image
        picker.allowsEditing = true
        // setting the source of image
        // if not nil then set, if nil then default from photo library
        if let sourceType = sourceType {
            picker.sourceType = sourceType
        }
        return picker
    }
    
    /// This is used to update the image picker controller if needed.
    /// Empty function for now.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    /// Returns the coordinator that is userd to transfer information i.e. image
    func makeCoordinator() -> Coordinator {
        return Coordinator(imagePicker: self)
    }
    
    /// The custom coordinator created for image picker
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let imagePicker: ImagePicker
        
        init(imagePicker: ImagePicker) {
            self.imagePicker = imagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                imagePicker.image = image
            } else {
                // This for when something wrong happened, like when they picked like a video or something
                // Return an error
                print("unable to convert")
            }
            picker.dismiss(animated: true)
        }
    }
}
