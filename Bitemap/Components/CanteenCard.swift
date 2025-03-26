//
//  ForYouCard.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct CanteenCard: View {
    var name: String
    var body: some View {
        HStack {
            Image(systemName:"fork.knife")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .padding(/*@START_MENU_TOKEN@*/.all, 8.0/*@END_MENU_TOKEN@*/)
                .frame(width: 100, height: 100)
            VStack{
                Color.green
                Color.blue
                Color.cyan
            }
        }
        .frame(height: 100)//Detail RightSide
        .border(Color.black .opacity(0.2))
    }
}

#Preview {
    CanteenCard()
}
