//
//  HomeView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 09/07/23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var homeViewModel = HomeViewModel()
    
    @ObservedObject var locationVM = LocationChangeViewViewModel.shared
    
    var isShowingView: Bool {
        return locationVM.isShowingLocationRangeView || locationVM.isShowingDomainView || locationVM.isShowingLocationView
    }

    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                topBar
                
                VStack {
                    locationView
                    
                    scrollableView
                        .refreshable {
                            homeViewModel.getFeedData()
                        }
                }
                .redacted(reason: homeViewModel.showRefreshingFeed ? .placeholder : [])
            }
            .task {
                homeViewModel.getFeedData()
            }
            .onTapGesture {
                locationVM.isShowingLocationView = false
                locationVM.isShowingDomainView = false
                locationVM.isShowingLocationRangeView = false
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(flixColor: .backgroundPrimary))
            .fullScreenCover(isPresented: $homeViewModel.showMessages) {
                AllMessagesView()
                    .environmentObject(homeViewModel)
            }
            .sheet(isPresented: $homeViewModel.showAddPostOrConnectionCallOptions,
                   onDismiss: { homeViewModel.getFeedData() },
                   content: {
                AddToPostOrConnectionCallOptionView()
                    .environmentObject(homeViewModel)
                    .presentationDetents([.fraction(0.25)])
            })
            .fullScreenCover(isPresented: $homeViewModel.showAddPostView,
                             onDismiss: { homeViewModel.getFeedData() },
                             content: {
                AddPostView()
            })
            .fullScreenCover(isPresented: $homeViewModel.showAddConnectionCallView,
                             onDismiss: { homeViewModel.getFeedData() },
                             content: {
                AddConnectionCallView()
            })
            .fullScreenCover(isPresented: $homeViewModel.showNotifications, content: {
                NotificationsView()
            })
        }
    }
}



extension HomeView {
    
    //MARK: - Location View
    
    private var locationView : some View {
        ZStack {
            LocationChangeView()
                .padding(.bottom, 8)
        }
    }
    
    //MARK: - Top Bar View
    private var topBar: some View {
        HStack {
            Text("flixdin")
                .font(.system(size: 24, weight: .bold))
            
            Spacer()
            
            Group {
                Button {
                    // Show Add View
                    homeViewModel.showAddPostOrConnectionCallOptions = true
                } label: {
                    Image(systemName: "plus.app")
                }
                
                Button {
                    homeViewModel.showNotifications = true
                } label: {
                    Image(systemName: "bell")
                }
                
                Button {
                    // Show message View
                    homeViewModel.showMessages = true
                } label: {
                    Image(systemName: "message")
                }
            }
            .font(.title2)
            .redacted(reason: homeViewModel.showRefreshingFeed ? .placeholder : [])
        }
        .foregroundColor(Color(flixColor: .lightOlive))
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    //MARK: - Scrollable View
    private var scrollableView: some View {
        ScrollView {
            
            VStack(spacing: 16) {
                
//                ClicksView()
                
//                Divider()
                
                VStack(spacing: 16) {
                    if homeViewModel.feedDataArray.isEmpty {
                        Text("No posts or connection calls")
                            .foregroundStyle(.secondary)
                            .font(.headline)
                    } else {
                        ForEach(homeViewModel.feedDataArray, id: \.postid) {data in
                            let key = data.postid.split(separator: ".").first
                            
                            if key == "post" {
                                PostCardView(post: .constant(UtilityFunction.getPostFrom(data: data)))
                            } else if key == "connectioncall" {
                                ConnectionCallCardView(connectionCall: UtilityFunction.getConnectionCallFrom(data: data))
                            } else {
//                                Text("DEBUG")
//                                    .foregroundStyle(.primary)
//                                    .font(.headline)
//                                    .foregroundColor(.red)
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
