//
//  SendersMessageView.swift
//  Flixdin
//
//  Created by KAARTHIKEYA K on 09/07/23.
//

import SwiftUI

struct SendersMessageView: View {
    
    @ObservedObject var viewModel = SenderMessageViewViewModel()
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            VStack (alignment: .leading) {
                ForEach(viewModel.senderMessage, id: \.self){ message in
                    Text(message)
                        .padding(12)
                        .background(Color(flixColor: .backgroundTernary))
                        .cornerRadius(8)
                }
            }
            .frame(maxWidth: 0.6 * UIScreen.main.bounds.width)
//            viewModel.senderImage
//                .frame(width:40, height: 40)
//                .aspectRatio(contentMode: .fill)
//                .cornerRadius(50)
        }
        .padding(.leading)
    }
}


struct SendersMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SendersMessageView()
    }
}
