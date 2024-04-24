//
//  FlixView.swift
//  Flixdin
//
//  Created by Prashanna Rajbhandari on 25/04/2024.
//

import SwiftUI

struct FlixView: View {
    @State var currentFlix = ""
    @State var showAddFlickView: Bool = false
    @StateObject var flixViewModel = FlixViewModel()

    var body: some View {
        GeometryReader { proxy in

            ZStack {
                TabView(selection: $currentFlix) {
                    ForEach(flixViewModel.allFlix) { flix in

                        FlixCell(flix: flix)

                            .frame(width: proxy.size.width)
                            .rotationEffect(Angle(degrees: -90))
                            .tag(flix)
                    }
                }
                .rotationEffect(Angle(degrees: 90))
                .frame(width: proxy.size.height)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: proxy.size.width)
                header()
            }
        }
        .background(Color.clear.ignoresSafeArea())
        .fullScreenCover(isPresented: $showAddFlickView, onDismiss: {}, content: {
            AddFlicksView(showAddFlicksView: $showAddFlickView)
        })
//        .onAppear(perform: {
//            Task {
//                await flixViewModel.getAllFlix()
//            }
//        })
    }
}

#Preview {
    FlixView()
}

extension FlixView {
    // MARK: header

    private func header() -> some View {
        HStack {
            Text("Flix")
                .font(.title.bold())
            Spacer()
            Button {
                showAddFlickView = true
            } label: {
                Image(systemName: "plus")
            }
            .shadow(radius: 8)
            .padding(4)
            .background(.regularMaterial)
            .cornerRadius(4)
            .foregroundColor(.accentColor)
        }
        .foregroundColor(.white)
        .padding([.horizontal], 24)
        .padding(.bottom)
        .background(.ultraThinMaterial)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
