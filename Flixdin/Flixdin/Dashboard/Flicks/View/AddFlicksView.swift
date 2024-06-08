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
    
    @Environment(\.dismiss) var dismiss
    
    @State var showingPicker = false
    @State var selectedVideoURL: URL?
    @Binding var showAddFlicksView: Bool

    @StateObject var addFlicksViewModel = AddFlicksViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                
                Divider()

                TextField("Caption", text: $addFlicksViewModel.caption)
                    .padding()
                
                Divider()

                TextField("Location", text: $addFlicksViewModel.location)
                    .padding()
                
                Divider()

                TextField("Domain", text: $addFlicksViewModel.domain)
                    .padding()
                
                Divider()
                
                Button {
                    if (!addFlicksViewModel.caption.isEmpty && !addFlicksViewModel.location.isEmpty && !addFlicksViewModel.domain.isEmpty){
                        
                        Task{
                            await addFlicksViewModel.addFlix()
                        }
                        showingPicker = true
                    }
                   
                } label: {
                    Text("Select video")
                        .padding()
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if let selectedVideoURL {
                    VideoPlayer(player: .init(url: selectedVideoURL))
                        .frame(height: 200)
                }
                
                Divider()
                
                Spacer()
                
                FlixdinButton(labelText: "Add Flix", showProgress: addFlicksViewModel.isUploading) {
                    var _ = print("flixid \(addFlicksViewModel.newFlixResponse)")
                    addFlicksViewModel.uploadSelectedVideo(pickedVideoURL: selectedVideoURL)
                }
                .padding(.horizontal)
                
//                Text("Flix Upload Status Code: \(addFlicksViewModel.status)")
                
                //respond to the status code based on the design
                //MARK: flow of this view:
                /*
                    1. user should add caption, location and domain first
                    2. Select video button performs a network call to send these data to the backend and gets the flixid as the response
                    3. Select the video that you want to upload
                    4. Post video button makes another POST request network call and uploads the video to the backend
                    5. A full screen progress view appears until the a response is given by the post video request
                 */

            }.overlay(content: {
                if addFlicksViewModel.isUploading {
                    Rectangle()
                        .fill(Color(flixColor: .backgroundPrimary))
                        .overlay {
                            if addFlicksViewModel.status != 0 {
                                PostedView()
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {dismiss()}
                                    }
                            } else {
                                VStack(spacing: 16) {
                                    ProgressView()
                                    Text("Uploading..")
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color(flixColor: .darkOlive))
                                }
                            }
                        }
                }
            })

            .fullScreenCover(isPresented: $showingPicker, content: {
                VideoPicker(videoURL: $selectedVideoURL)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.flixColorBackgroundPrimary)
            .navigationTitle("Add Flix")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddFlicksView = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundStyle(.accent)
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
