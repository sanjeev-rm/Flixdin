//
//  ViewerClickView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 12/07/23.
//

import SwiftUI

struct ViewerClickView: View {
    
    @EnvironmentObject var clicksData: ViewerClicksViewViewModel
    
    var body: some View {
        
        if clicksData.showClick {
            
            TabView(selection: $clicksData.currentClick) {
                ForEach($clicksData.clicks) { $story in
                    ClicksCardView(bundle: $story)
                        .environmentObject(clicksData)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            
            // Close Button
            .overlay(
                
                Button(action: {
                    withAnimation {
                        clicksData.showClick = false
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.white)
                })
                .padding(),
                alignment: .topTrailing
            )
            .transition(.move(edge: .bottom))
        }
        
    }
}

struct ClicksCardView: View {
    
    @Binding var bundle:  ClicksBundle
    @EnvironmentObject var clicksData: ViewerClicksViewViewModel
    
    // For Timer and Changing Clicks.
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var timerProgress : CGFloat = 0
    
    var body: some View {
        
        GeometryReader { geoProxy in
            
            ZStack {
                
                // Getting the Index of the Click
                let index = min(Int(timerProgress), bundle.clicks.count - 1)
                
                if index < bundle.clicks.count {
                    let click = bundle.clicks[index]
                    click.ClickImage
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            // For Tapping.
            .overlay(
                HStack {
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            if timerProgress - 1 < 0 {
                                updateClikcs(forward: false)
                            } else {
                                timerProgress = CGFloat(Int(timerProgress - 1))
                            }
                        }
                    
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            // Checking and updating to next.
                            if timerProgress + 1 > CGFloat(bundle.clicks.count) {
                                updateClikcs()
                            } else {
                                // Update to next Click
                                timerProgress = CGFloat(Int(timerProgress + 1))
                            }
                        }
                }
            )
            .overlay(
                
                HStack(spacing: 13, content: {
                    
                    bundle.user.displayProfilePic
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Text(bundle.user.username)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    Spacer()
                })
                .padding(),

                alignment: .topTrailing
                
            )
            
            // Top Timer.
            
            .overlay(
                HStack (spacing: 5, content: {
                    ForEach(bundle.clicks.indices) { index in
                        
                        GeometryReader { geo in
                            
                            let width = geo.size.width
                            
                            // eliminate current index so that there will be different progresses.
                            let progress = timerProgress - CGFloat(index)
                            let perfectProgress = min(max(progress, 0), 1)
                            
                            Capsule()
                                .fill(.gray.opacity(0.5))
                                .overlay(
                                    Capsule()
                                        .fill(.white)
                                        .frame(width: width * perfectProgress), alignment: .leading
                                )
                            
                        }
                        
                    }
                })
                .frame(height: 2)
                .padding(.horizontal), alignment: .top
            )
            .rotation3DEffect(getAngle(proxy: geoProxy), axis: (x: 0, y: 1, z: 0),
                              anchor: geoProxy.frame(in: .global).minX > 0 ? .leading : .trailing, perspective: 2)
        }
        .onAppear(perform: {
            timerProgress = 0
        })
        .onReceive(timer) { _ in
            
            // Updating the seen status.
            if clicksData.currentClick == bundle.id {
                if !bundle.isSeen {
                    bundle.isSeen = true
                }
                
                // Updating the Timer
                if timerProgress < CGFloat(bundle.clicks.count) {
                    timerProgress += 0.015
                } else {
                    updateClikcs()
                }
            }
        }
        
    }
    
    // updating the view on the end of the timer.
    
    func updateClikcs(forward: Bool = true){
        let index = min(Int(timerProgress), bundle.clicks.count - 1)
        let click = bundle.clicks[index]
        
        if !forward {
            // If first then set timer to 0 else move backward.
            if let first = clicksData.clicks.first, first.id != bundle.id {
                // Getting Index.
                let bundleIndex = clicksData.clicks.firstIndex{ currentBundle in
                    return bundle.id == currentBundle.id
                } ?? 0
                
                withAnimation {
                    clicksData.currentClick = clicksData.clicks[bundleIndex - 1].id
                }
            } else {
                timerProgress = 0
            }
        }
        
        if let last = bundle.clicks.last, last.id == click.id {
            if let lastBundle = clicksData.clicks.last, lastBundle.id == bundle.id {
                // Closing..
                withAnimation {
                    clicksData.showClick = false
                }
                timerProgress = 0
            } else {
                // Updating to the next one.
                let bundleIndex = clicksData.clicks.firstIndex{ currentBundle in
                    return bundle.id == currentBundle.id
                } ?? 0
                
                withAnimation {
                    clicksData.currentClick = clicksData.clicks[bundleIndex + 1].id
                }
            }
        }
    }
    
    func getAngle(proxy: GeometryProxy) -> Angle {
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let rotationAngle : CGFloat = 45
        let degress = rotationAngle * progress
        return Angle(degrees: Double(degress))
    }
    
}

struct ViewerClickView_Previews: PreviewProvider {
    static var previews: some View {
        ClicksView()
    }
}
