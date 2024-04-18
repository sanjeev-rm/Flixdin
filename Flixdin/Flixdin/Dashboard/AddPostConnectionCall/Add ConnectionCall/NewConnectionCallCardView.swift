//
//  NewConnectionCallCardView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/08/23.
//

import SwiftUI
import PhotosUI

struct NewConnectionCallCardView: View {
    
    @EnvironmentObject var newConnectionCallVM: NewConnectionCallViewModel
    
    @FocusState var isKeyboardActive: Bool
    
    var body: some View {
        newConnectionCallCardView
    }
}



extension NewConnectionCallCardView {
    private var newConnectionCallCardView: some View {
        VStack(alignment: .leading, spacing: 16) {
            profilePictureAndInfo
            needConnectionOption
            addLocation
            connectionCallDetailView
        }
        .padding()
        .background(Color(flixColor: .backgroundSecondary))
        .cornerRadius(16)
        .padding()
        .background(Color(flixColor: .backgroundPrimary))
        .sheet(isPresented: $newConnectionCallVM.showLocationSearcher,
               onDismiss: {
            print(newConnectionCallVM.connectionLocationPlace.place.name!)
            if newConnectionCallVM.connectionLocationPlace.place != Place().place {
                newConnectionCallVM.connectionLocation = newConnectionCallVM.connectionLocationPlace.place.name!
            }
        }, content: {
            SearchPlaceView(selectedPlace: $newConnectionCallVM.connectionLocationPlace)
        })
    }
    
    private var profilePictureAndInfo: some View {
        HStack(spacing: 16) {
            ProfilePictureView(imageUrl: URL(string: newConnectionCallVM.currentUser.profilePic ?? ""), borderColor: .clear, borderWidth: 0, imageWidth: 44, imageHeight: 44)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(newConnectionCallVM.currentUser.fullName).font(.headline)
                Text(newConnectionCallVM.currentUser.domain)
            }
            .font(.caption2)
        }
        .redacted(reason: newConnectionCallVM.currentUser.id == User().id ? .placeholder : [])
    }
    
    private var needConnectionOption: some View {
        HStack {
            Text("Need")
            Picker("Need", selection: $newConnectionCallVM.selectedDomain) {
                ForEach(Domain.allCases, id: \.self) { domain in
                    Text(domain.title)
                        .font(.caption)
                }
            }
            .background(Color(flixColor: .backgroundTernary))
            .cornerRadius(8)
            Text("Connection")
        }
        .font(.caption)
    }
    
    private var addLocation: some View {
        HStack {
            Image(systemName: "mappin")
                .foregroundColor(.accent)
            Spacer()
            Button {
                newConnectionCallVM.showLocationSearcher = true
            } label: {
                HStack {
                    //                    TextField("Add connection location", text: $newConnectionCallVM.connectionLocation)
                    //                        .focused($isKeyboardActive)
                    //                        .font(.footnote)
                    if newConnectionCallVM.connectionLocationPlace.place.name! != Place().place.name! {
                        Text(newConnectionCallVM.connectionLocationPlace.place.name!)
                            .fontWeight(.medium)
                            .foregroundColor(.primary.opacity(0.6))
                    } else {
                        Text("Add connection call location")
                            .font(.callout)
                    }
                    Spacer()
                }
                .padding(8)
                .background(Color(flixColor: .backgroundTernary))
                .cornerRadius(8)
            }
        }
    }
    
    private var connectionCallDetailView: some View {
        VStack {
            ScrollView {
                TextField("Add Job Description", text: $newConnectionCallVM.description, axis: .vertical)
                    .focused($isKeyboardActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isKeyboardActive = false
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                
                if !newConnectionCallVM.selectedImages.isEmpty {
                    VStack {
                        ForEach(newConnectionCallVM.selectedImages, id: \.self) { uiimage in
                            Image(uiImage: uiimage)
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(16)
                        }
                    }
                }
            }
            
//            Spacer()
            
            // MARK: For adding an Image
//            HStack {
//                Spacer()
//                
//                PhotosPicker(selection: $newConnectionCallVM.selectedImageItems,
//                             matching: .images,
//                             label: { Image(systemName: "photo")}
//                )
//                .onChange(of: newConnectionCallVM.selectedImageItems) { newImageItems in
//                    Task {
//                        newConnectionCallVM.selectedImages = []
//                        for imageItem in newImageItems {
//                            if let imageData = try? await imageItem.loadTransferable(type: Data.self),
//                               let uiImage = UIImage(data: imageData) {
//                                newConnectionCallVM.selectedImages.append(uiImage)
//                            }
//                        }
//                    }
//                }
//            }
        }
        .padding(8)
        .background(Color(flixColor: .backgroundTernary))
        .cornerRadius(8)
    }
}

struct NewConnectionCallCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        NewConnectionCallCardView()
            .environmentObject(NewConnectionCallViewModel())
    }
}
