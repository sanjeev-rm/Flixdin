//
//  ExploreView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//

import SwiftUI

struct ExploreView: View {
    
    @ObservedObject var locationVM = LocationChangeViewViewModel.shared
    
    @State var searchQuery: String = ""
    @State var searchUserResult: [User] = []
    
    var isShowingView: Bool {
        return locationVM.isShowingLocationRangeView || locationVM.isShowingDomainView || locationVM.isShowingLocationView
    }
    
    var body: some View {
        NavigationView {
            if #available(iOS 17.0, *) {
                baseView
                    .onChange(of: searchQuery) { oldValue, newValue in
                        ExploreViewModel.searchUser(query: searchQuery) { searchUserResult in
                            self.searchUserResult = searchUserResult
                        }
                    }
            } else {
                baseView
                    .onChange(of: searchQuery, perform: { value in
                        ExploreViewModel.searchUser(query: searchQuery) { searchUserResult in
                            self.searchUserResult = searchUserResult
                        }
                    })
            }
        }
    }
}

extension ExploreView {
    
    private var baseView: some View {
        VStack {
            SearchFieldView(backgroundColor: Color(flixColor: .backgroundSecondary), searchQuery: $searchQuery)
                .padding(.horizontal)
            LocationChangeView()
                .padding(8)
            if searchQuery.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(1...3, id: \.self) { i in
                        LeftVerticalPicture()
                        NoVerticalPicture()
                        RightVerticalPicture()
                    }
                }
            } else {
//                ExploreUsersListView(users: $searchUserResult)
                List {
                    ForEach(searchUserResult, id: \.id) { user in
                        UserCardView(user: user)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
        .scrollDismissesKeyboard(.immediately)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
