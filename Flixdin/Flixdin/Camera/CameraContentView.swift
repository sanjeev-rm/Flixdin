//
//  CameraContentView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 01/08/23.
//

import SwiftUI

struct CameraContentView: View {
    
    @Binding var capturedImage: UIImage?
    @Binding var isCameraContentViewPresented: Bool
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack (alignment: .leading){
            ZStack {
                if capturedImage != nil {
                    Image(uiImage: capturedImage!)
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                } else {
                    Color(UIColor.systemBackground)
                }
                VStack{
                    HStack {
                        Button {
                            capturedImage = nil
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.primary)
                                .font(.system(size: 24))
                                .padding()
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            
            HStack (spacing: 16) {
                
                Button {
                    // Adding to Click
                } label: {
                    Text("Add to Click")
                        .font(.system(.headline))
                        .foregroundColor(.white)
                        .padding(8)
                        .padding(.horizontal)
                        .background(
                            Rectangle()
                                .foregroundColor(.gray)
                                .opacity(0.8)
                                .cornerRadius(32)
                        )
                }
                                
                Button {
                    // Gallery
                } label: {
                    Text("Share To")
                        .font(.system(.headline))
                        .foregroundColor(.white)
                        .padding(8)
                        .padding(.horizontal)
                        .background(
                            Rectangle()
                                .foregroundColor(.gray)
                                .opacity(0.8)
                                .cornerRadius(32)
                        )
                }
            }
            .padding(.horizontal)
            .padding(.top)

        }
        .background(
            Color(.black)
        )
    }
}

