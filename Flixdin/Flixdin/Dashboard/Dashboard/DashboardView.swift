//
//  DashboardView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 05/07/23.
//

import SwiftUI

struct DashboardView: View {
    
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State private var selection = 0
    @State private var resetNavigationIds: [UUID] = [UUID(), UUID(), UUID(), UUID(), UUID()]
    
    var body: some View {
        
        // << proxy binding to catch tab tap
        var selectable : Binding<Int> {Binding(
            get: { self.selection },
            set: {
//                print("DEBUG: Tag - \($0), \(self.selection)")
                if $0 == self.selection {
                    // set new ID to recreate NavigationView, so put it in root state, same as is on change tab and back
                    self.resetNavigationIds[$0] = UUID()
                }
                self.selection = $0
            }
        )}
        
        return TabView(selection: selectable) {
            HomeView()
                .id(resetNavigationIds[0])
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            ExploreView()
                .id(resetNavigationIds[1])
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            ConnectionCallView()
                .id(resetNavigationIds[2])
                .tabItem {
                    Label("Connection Call", systemImage: "film.stack")
                }
                .tag(2)
            
            FlicksView()
                .id(resetNavigationIds[3])
                .tabItem {
                    Label("Flicks", systemImage: "film")
                }
                .toolbarBackground(Color(flixColor: .backgroundPrimary), for: .tabBar)
                .tag(3)
            
            ProfileView()
                .id(resetNavigationIds[4])
                .environmentObject(authViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(4)
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(Color(flixColor: .backgroundPrimary))
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            
//            let navigationBarAppearance = UINavigationBarAppearance()
//            navigationBarAppearance.configureWithOpaqueBackground()
//            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
        .onAppear {
            UtilityFunction.getCurrentUser { user in
                print("DEBUG: got current user" + ((user == nil) ? "[NOPE]" : ", ID - \(user!.id)"))
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(AuthenticationViewModel())
    }
}
