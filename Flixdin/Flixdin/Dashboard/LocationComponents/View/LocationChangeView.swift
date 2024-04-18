//
//  LocationChangeView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 15/07/23.
//

import SwiftUI

struct LocationChangeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var LocationVM = LocationChangeViewViewModel.shared
    
    var body: some View {
        
        allLocationsView
            .sheet(isPresented: $LocationVM.isShowingDomainView) {
                SelectDomainView()
                    .presentationDetents([.fraction(0.75)])
            }
            .sheet(isPresented: $LocationVM.isShowingLocationView) {
                CompleteLocationView()
                    .presentationDetents([.fraction(0.9)])
            }
            .sheet(isPresented: $LocationVM.isShowingLocationRangeView) {
                LocaitonRangeView()
                    .presentationDetents([.fraction(0.2)])
            }
    }
}

extension LocationChangeView {
    private var allLocationsView: some View {
        
        VStack {
            
            HStack (spacing: 10) {
                
                LocationChangeButton(selectedButton: $LocationVM.selectedButton, title: "All") { title in
                    LocationVM.selectedButton = title
                    LocationVM.isShowingLocationRangeView = false
                }
                
                LocationChangeButton(selectedButton: $LocationVM.selectedButton, title: "Near Me") { title in
                    LocationVM.selectedButton = title
                    LocationVM.isShowingLocationRangeView = false
                }
                
                LocationChangeButton(selectedButton: $LocationVM.selectedButton, title: "Location") { title in
                    LocationVM.selectedButton = title
                    LocationVM.isShowingLocationView.toggle()
                    LocationVM.isShowingLocationRangeView = false
                }
                
                LocationChangeButton(selectedButton: $LocationVM.selectedButton, title: "Domain") { title in
                    LocationVM.selectedButton = title
                    LocationVM.isShowingDomainView.toggle()
                    LocationVM.isShowingLocationRangeView = false
                }
                
                Button {
                    LocationVM.selectedButton = "location"
                    LocationVM.isShowingLocationRangeView.toggle()
                } label: {
                    Image(systemName: "location.circle")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .padding(8)
                        .background(
                            Rectangle()
                                .foregroundColor(colorScheme == .dark ? (LocationVM.selectedButton == "location" ? .init(flixColor: .lightOlive) : .gray.opacity(0.1)) : (LocationVM.selectedButton == "location" ? .init(flixColor: .lightOlive) : Color(flixColor: .lightBlack).opacity(0.6)))
                            
                                .cornerRadius(8)
                        )
                }
            }
        }
    }
}

struct LocationChangeButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedButton : String
    
    let title: String
    let action : (String) -> Void
    
    var body: some View {
        Button(action: {action(title)}) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 12, weight: .semibold))
                .padding(8)
                .padding(.horizontal, 8)
                .background(
                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? (selectedButton == title ? .init(flixColor: .lightOlive) : .gray.opacity(0.1)) : (selectedButton == title ? .init(flixColor: .lightOlive) : Color(flixColor: .lightBlack).opacity(0.6)))
                        .cornerRadius(8)
                )
        }
    }
}

struct LocationChangeView_Previews: PreviewProvider {
    static var previews: some View {
        LocationChangeView()
            .environmentObject(LocationChangeViewViewModel())
    }
}
