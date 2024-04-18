//
//  AddFlicksView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 10/04/24.
//

import AVKit
import PhotosUI
import SwiftUI

struct AddFlicksView: View {
    @State var showingPicker = false
    @State var selectedVideoURL: URL?
    @Binding var showAddFlicksView: Bool

    @StateObject var addFlicksViewModel = AddFlicksViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if let selectedVideoURL {
                    VideoPlayer(player: .init(url: selectedVideoURL))
                        .frame(height: 200)
                }

                Button("Select Video") {
                    showingPicker = true
                }

                Button("Post Video") {
                    addFlicksViewModel.uploadSelectedVideo(pickedVideoURL: selectedVideoURL)
                }
                
                Spacer()
                
            }.overlay(content: {
                if addFlicksViewModel.isUploading {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            ProgressView()
                        }
                }
            })

            .fullScreenCover(isPresented: $showingPicker, content: {
                VideoPicker(videoURL: $selectedVideoURL)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.flixColorBackgroundPrimary)
            .navigationTitle("Add Flick")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddFlicksView = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    AddFlicksView(showAddFlicksView: .constant(true))
}

// MARK: Video Picker Transferable

struct VideoPickerTransferable: Transferable {
    let videoURL: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            .init(exportingFile.videoURL)
        } importing: { ReceivedTransferredFile in
            let originalFile = ReceivedTransferredFile.file
            let copiedFile = URL.documentsDirectory.appending(path: "videoPicker.mov")

            if FileManager.default.fileExists(atPath: copiedFile.path()) {
                try FileManager.default.removeItem(at: copiedFile)
            }

            try FileManager.default.copyItem(at: originalFile, to: copiedFile)

            return .init(videoURL: copiedFile)
        }
    }
}


