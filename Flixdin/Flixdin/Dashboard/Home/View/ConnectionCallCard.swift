//
//  ConnectionCallCard.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 04/07/23.
//

import SwiftUI

struct ConnectionCallCard: View {
    
    @State var isLiked: Bool = false
    @State var isSaved: Bool = false

    
    var body: some View {
        
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(Color(red: 0.25, green: 0.25, blue: 0.25))
                    .frame(width: 375, height: 230)
                    .cornerRadius(15)
                VStack {
                    HStack  {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 39.31412, height: 38)
                            .background(
                                Image(uiImage: UIImage(systemName: "person.fill")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 39.3, height: 38)
                                    .clipped()
                            )
                            .cornerRadius(39.31412)
                            .padding(.leading, 10)
                            .padding(.trailing, 13.45)
                        
                        VStack ( alignment: .leading ) {
                            Text("Username")
                                .font(
                                    Font.custom("Inter", size: 17.3)
                                        .weight(.bold)
                                )
                                .foregroundColor(.white)
                            Text("Field")
                                .frame(alignment: .topLeading)
                                .font(Font.custom("Inter", size: 15.2))
                                .foregroundColor(.white)
                            
                        }
                        
                        Button {
                            print("Edit is tapped.")
                        } label: {
                            Label("", systemImage: "ellipsis")
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 168.64)
                        
                    }
                    
                    VStack{
                        HStack {
                            Text("Need")
                              .font(Font.custom("Inter", size: 15.2))
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 40.3, height: 10, alignment: .center)
                            ZStack {
                                Rectangle()
                                  .foregroundColor(.clear)
                                  .frame(width: 167.60231, height: 23)
                                  .background(Color(flixColor: .lightBlack))
                                  .cornerRadius(5)
                                Text("Domain Needed")
                                  .font(Font.custom("Inter", size: 15))
                                  .multilineTextAlignment(.center)
                                  .foregroundColor(.white)
                                  .frame(width: 137.5, height: 10, alignment: .center)
                            }
                            Text("Connection")
                                .font(Font.custom("Inter", size: 15.2))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 83.8, height: 10)
                        }
                        
                        
                        HStack {
                            Image(systemName: "mappin")
                                .foregroundColor(.white)
                            ZStack {
                                Rectangle()
                                  .foregroundColor(.clear)
                                  .frame(width: 276.2, height: 23)
                                  .background(Color(flixColor: .lightBlack))
                                  .cornerRadius(5)
                                Text("Location")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 10)
                        
                        HStack {
                            Text("Number of Applicants :")
                              .font(
                                Font.custom("Inter", size: 12)
                                  .weight(.light)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 129.3, height: 10, alignment: .center)
                              .padding(.leading, 184.33)
                            Text("18")
                              .font(
                                Font.custom("Inter", size: 12)
                                  .weight(.light)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 13.4, height: 10, alignment: .center)
                        }
                    }
                    .padding(.top, 15)
                    
                    HStack {
                        Button {
                            self.isLiked.toggle()
                            print(isLiked)
                        } label: {
                            Label("", systemImage: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .white)
                            
                        }
                        .padding(.leading, 26.03)
                        Button {
                            print("Message is pressed.")
                        } label: {
                            Label("", systemImage: "message")
                                .foregroundColor(.white)
                        }
                        Button {
                            print("Share is pressed.")
                        } label: {
                            Label("", systemImage: "paperplane")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 131.94)
                        
                        ZStack{
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 70.53151, height: 28)
                              .background(Color(red: 0.69, green: 0.6, blue: 0.12))
                              .cornerRadius(6.08696)
                            
                            Text("Apply")
                              .font(
                                Font.custom("Inter", size: 15.8)
                                  .weight(.medium)
                              )
                              .multilineTextAlignment(.center)
                              .foregroundColor(.white)
                              .frame(width: 61.71, height: 12, alignment: .center)
                        }
                        
                        Button {
                            self.isSaved.toggle()
                            print("Save is pressed.")
                        } label: {
                            Label("", systemImage: isSaved ? "bookmark.fill": "bookmark")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 15)

                    }
                    .padding(.top, 7)
                }
            }
        }
}

struct ConnectionCallCard_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionCallCard()
    }
}
