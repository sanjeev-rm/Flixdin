//
//  FlixdinImageView.swift
//  Flixdin
//
//  Created by Sanjeev RM on 08/03/24.
//

import SwiftUI

struct FlixdinImageView: View {
    var urlString: String
    @Binding var contentImage: Image?
    
    var body: some View {
        
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .foregroundStyle(Color(flixColor: .backgroundTernary))
                    .aspectRatio(contentMode: .fit)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear {
                        contentImage = image
                    }
            case .failure(_):
                Rectangle()
                    .foregroundStyle(Color(flixColor: .backgroundTernary))
                    .aspectRatio(contentMode: .fit)
            @unknown default:
                fatalError()
            }
        }
    }
}

#Preview {
    FlixdinImageView(urlString: SAMPLE_POST.image, contentImage: .constant(Image("")))
}
