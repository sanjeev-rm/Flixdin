//
//  ClicksView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//

import SwiftUI

struct ClicksView: View {
    
    @StateObject var clicksData = ViewerClicksViewViewModel()
    
    @State var capturedImage: UIImage? = nil
    @State private var isCustomCameraViewPresented: Bool = false
    @State var isCameraContentViewPresented: Bool = false
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                
                addToStoryView
                
                otherStoryView
                
            }
            .padding(.horizontal, 16)
        }
    }
}

extension ClicksView {
    
    // Add to Story View
    
    private var addToStoryView : some View {
        Button {
            isCameraContentViewPresented.toggle()
        } label: {
            ZStack(alignment: .bottomTrailing){
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 65, height: 65)
                    .cornerRadius(65)
                    .background(
                        AsyncImage(url: URL(string: "https://picsum.photos/65/65"))
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(65)
                    )
                
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                    
                    Circle()
                        .foregroundColor(Color(flixColor: .lightOlive))
                        .frame(width: 20, height: 20)
                    
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(2)
                        .frame(width: 15, height: 15)
                }
                .offset(x:4, y:4)
            }
        }
        .fullScreenCover(isPresented: $isCameraContentViewPresented) {
            CustomCameraView(capturedImage: $capturedImage)
        }
    }
    
    // Other Story View
    
    private var otherStoryView: some View {
        VStack{
            HStack(spacing: 12) {
                // Get the data from the database the number of users and display here.
                ForEach($clicksData.clicks) { $bundle in
                    
                    ClicksProfileView(bundle: $bundle)
                        .environmentObject(clicksData)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $clicksData.showClick) {
            ViewerClickView()
                .environmentObject(clicksData)
        }
    }
}

struct ClicksProfileView: View {
    
    @Binding var bundle: ClicksBundle
    @EnvironmentObject var clicksData: ViewerClicksViewViewModel
    
    var body: some View {

        bundle.user.displayProfilePic
            .aspectRatio(contentMode: .fill)
            .frame(width: 65, height: 65)
            .clipShape(Circle())
            .padding(3)
        
        // Progress Ring for the Click to be seen or not.
            .background((Color(flixColor: .backgroundPrimary)), in: Circle())
            .padding(2)
            .background(LinearGradient(colors: [.init(flixColor: .backgroundSecondary),
                                                .init(flixColor: .backgroundTernary),
                                                .init(flixColor: .backgroundSecondary),
                                                .init(flixColor: .backgroundTernary)],
                                       startPoint: .top, endPoint: .bottom)
                .clipShape(Circle())
                .opacity(bundle.isSeen ? 0 : 1)
            )
            .onTapGesture {
                withAnimation {
                    bundle.isSeen = true
                    
                    clicksData.currentClick = bundle.id
                    clicksData.showClick = true
                }
            }
    }
    
}

struct ClicksView_Previews: PreviewProvider {
    static var previews: some View {
        ClicksView()
    }
}


