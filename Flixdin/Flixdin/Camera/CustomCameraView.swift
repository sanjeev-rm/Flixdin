//
//  CustomCameraView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 01/08/23.
//

import SwiftUI
import PhotosUI

struct CustomCameraView: View {
    
    let cameraService = CameraService()
    
    @Binding var capturedImage: UIImage?
    
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @State private var isCameraButtonPressed: Bool = false
    @State var isCameraContentViewPresented: Bool = true
    @State var isCustomCameraViewPresented: Bool = false
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack {
            ZStack {
                CameraView(cameraService: cameraService) { result in
                    switch result {
                    case .success(let photo):
                        if let data = photo.fileDataRepresentation() {
                            capturedImage = UIImage(data: data)
                        } else {
                            print("Error: no image data found")
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
                
                VStack {
                    HStack (alignment: .top){
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(.title2))
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        Spacer()
                        
                        VStack (spacing: 20){
                            
                            Button {
                                cameraService.toggleFlash()
                            } label: {
                                Image(systemName: "bolt.fill")
                                    .font(.system(.title2))
                                    .foregroundColor(.white)
                            }
                            
                            
                            Button {
                                cameraService.switchCamera { error in
                                    if let error = error {
                                        print("Error switching camera: \(error)")
                                    }
                                }
                            } label: {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(.title2))
                                    .foregroundColor(.white)
                            }
                            
                            PhotosPicker(
                                selection: $selectedImageItem,
                                matching: .images,
                                photoLibrary: .shared()) {
                                    Image(systemName: "photo")
                                        .font(.system(.title2))
                                        .foregroundColor(.white)
                                    
                                }
                                .onChange(of: selectedImageItem) { newItem in
                                    Task {
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            selectedImageData = data
                                            capturedImage = UIImage(data: data)
                                        }
                                    }
                                    isCameraButtonPressed.toggle()
                                }
                        }
                        .padding()
                        
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        cameraService.capturePhoto()
                        isCameraButtonPressed.toggle()
                    }, label: {
                        Image(systemName: "circle")
                            .font(.system(size: 72))
                            .foregroundColor(.white)
                    })
                    .fullScreenCover(isPresented: $isCameraButtonPressed, content: {
                        CameraContentView(capturedImage: $capturedImage, isCameraContentViewPresented: $isCameraContentViewPresented)
                    })
                    .padding(.bottom)
                }
            }
        }
        .background(
            Color(flixColor: .backgroundPrimary)
        )
    }
}
