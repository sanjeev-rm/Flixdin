//
//  ReceiversMessageView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 09/07/23.
//

import SwiftUI

struct ReceiversMessageView: View {
    
    @ObservedObject var viewModel = ReceiversMessageViewViewModel()
    
    var body: some View {
        
        HStack {
            
//            viewModel.receiverImage
//                .frame(width:40, height: 40)
//                .aspectRatio(contentMode: .fill)
//                .cornerRadius(50)

            VStack (alignment: .leading) {
                ForEach(viewModel.receiverMessage, id: \.self){ message in
                    Text(message)
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: 0.6 * UIScreen.main.bounds.width)
            
            Spacer()
        }

    }
}

struct ReceiversMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiversMessageView()
    }
}
