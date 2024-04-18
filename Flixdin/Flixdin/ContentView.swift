//
//  ContentView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 04/07/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(flixImage: .logo)
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Hello, World!")
                .font(.largeTitle.monospaced().bold())
                .foregroundColor(Color(flixColor: .darkOlive))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(flixColor: .backgroundPrimary))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
