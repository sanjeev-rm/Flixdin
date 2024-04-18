//
//  ProfilePictureView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 08/08/23.
//

import SwiftUI

struct ProfilePictureView: View {
    
    let imageUrl: URL?
    let borderColor: Color
    let borderWidth: CGFloat
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    
    var body: some View {
        AsyncImage(url: imageUrl) { image in
            image
                .resizable()
        } placeholder: {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(.secondarySystemFill))
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: imageWidth, height: imageHeight)
        .clipShape(Circle())
        .padding(1)
        .overlay(
            Circle()
                .stroke(borderColor, lineWidth: borderWidth)
        )

//        ZStack {
//            if let imageName = imageUrl {
//                AsyncImage(url: imageName)
//            } else {
//                Image(systemName: "person.crop.circle.fill")
//                    .resizable()
//                    .scaledToFill()
//                    .foregroundColor(Color(.secondarySystemFill))
//            }
//        }
//        .aspectRatio(contentMode: .fill)
//        .frame(width: imageWidth, height: imageHeight)
//        .clipShape(Circle())
//        .padding(3)
//        .overlay(
//            Circle()
//                .stroke(borderColor, lineWidth: borderWidth)
//        )
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView(imageUrl: URL(string: "https://minio.flixdin.com/test/profilePic/sHaJdckHqWN8uWMTf2uD4rPGags2"), borderColor: Color(.black), borderWidth: 0, imageWidth: 50, imageHeight: 50)
    }
}
