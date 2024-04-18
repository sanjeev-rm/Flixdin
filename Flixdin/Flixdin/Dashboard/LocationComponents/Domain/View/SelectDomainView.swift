//
//  SelectDomainView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 05/07/23.
//

import SwiftUI

struct SelectDomainView: View {
    
    var body: some View {
        
        VStack {
            
            selectDomainHeaderView
            
            DomainSelectionView
        } 
        .padding()
        .background(
            Rectangle()
                .foregroundColor(.clear)
                .background(Color(flixColor: .backgroundSecondary))
                .cornerRadius(8)
                .padding(.horizontal)
            
        )
        .padding()
    }
}

extension SelectDomainView {
    
    //MARK: - Select Domain Header View.
    private var selectDomainHeaderView: some View {
        VStack{
            Text("Select Domain")
                .font(.system(size: 16))
                .foregroundColor(.primary)
            Divider()
                .frame(width: UIScreen.main.bounds.width - 50, height: 2)
                .background(Color(flixColor: .olive))
        }
    }
    
    //MARK: - Domains
    
    private var DomainSelectionView: some View {
        DomainsView()
    }
}

struct SelectDomainView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDomainView()
    }
}
