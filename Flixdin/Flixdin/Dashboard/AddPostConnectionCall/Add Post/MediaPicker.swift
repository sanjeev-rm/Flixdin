//
//  MediaPicker.swift
//  Flixdin
//
//  Created by Sanjeev RM on 15/08/23.
//

import Foundation

import SwiftUI
import YPImagePicker

struct MediaPicker: UIViewControllerRepresentable {
  
    class Coordinator: NSObject, UINavigationControllerDelegate {
        let parent: MediaPicker
        
        init(_ parent: MediaPicker) {
            self.parent = parent
        }
    }

    typealias UIViewControllerType = YPImagePicker
    @Binding var images: [UIImage]?
    @Binding var thumbnail: UIImage?
    
    func makeUIViewController(context: Context) -> YPImagePicker {
        var config = YPImagePickerConfiguration()
       
        //Common
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "Flixdin"
        config.showsPhotoFilters = true
        config.showsCrop = .rectangle(ratio: 1)
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.bottomMenuItemSelectedTextColour = .systemCyan
        
        //library
        config.library.mediaType = .photo
        config.library.maxNumberOfItems = 1
    
        config.wordings.libraryTitle = "Gallery"
        config.targetImageSize = .cappedTo(size: 1080)
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { items, cancelled in
            images = []
            var thumbnails: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let ypPhoto):
                    self.images?.append(ypPhoto.image)
                    thumbnails.append(ypPhoto.image)
                case .video(let ypVideo):
                    print("DEBUG: Handle for videos \(ypVideo.fromCamera)")
                    thumbnails.append(ypVideo.thumbnail)
                }
            }
            if !thumbnails.isEmpty {
                thumbnail = thumbnails[0]
            }
            picker.dismiss(animated: true, completion: nil)
        }
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
