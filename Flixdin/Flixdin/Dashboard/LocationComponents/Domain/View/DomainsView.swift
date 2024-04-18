//
//  DomainsView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 07/07/23.
//

import SwiftUI

var domains : [String] = ["Actor", "Animation", "Art Director", "Cinematographer", "Director", "Editor", "Film Gear", "Film Critic", "Music Director", "Producer", "Production House", "Screen Writer", "Sound Designer", "VFX artist", "Writer"]


struct DomainsView: View {
    
    @State private var isSelected: [Bool] = Array(repeating: false, count: domains.count)
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 10){
            ForEach(domains.indices, id: \.self) {domain in
                HStack {
                    Button() {
                        self.selectButton(at: domain)
                    } label: {
                        Text(domains[domain])
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    if self.isSelected[domain] {
                        Image(systemName: "record.circle")
                            .padding(.trailing, 20)
                    }
                }
            }
        }
        .padding(.horizontal, 15)
    }
    
    func selectButton(at index: Int) {
        isSelected.indices.forEach { buttonIndex in
            isSelected[buttonIndex] = buttonIndex == index
        }
    }

}

struct DomainsView_Previews: PreviewProvider {
    static var previews: some View {
        DomainsView()
    }
}
