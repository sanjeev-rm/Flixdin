//
//  VideoPicker.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 11/04/2024.
//

import Foundation
import SwiftUI
import YPImagePicker

import SwiftUI
import YPImagePicker

struct VideoPicker: UIViewControllerRepresentable {
    
    @Binding var videoURL: URL?
    class Coordinator: NSObject, UINavigationControllerDelegate {
        let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
    }

    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .video]
        config.library.mediaType = .video
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.showsVideoTrimmer = true
        config.video.trimmerMaxDuration = 60.0
        config.video.trimmerMinDuration = 3.0

        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let video = items.singleVideo {
                self.videoURL = video.url
            }
            picker.dismiss(animated: true, completion: nil)
     
        }
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
