//
//  ForYouCard.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct CanteenCard: View {
    var body: some View {
        HStack {
            Color.blue // IMG
                .aspectRatio(CGFloat(1), contentMode: .fit)
            VStack{
                Color.green
                Color.blue
                Color.cyan
            }
        }
        .frame(height: 100)//Detail RightSide
//        .padding(32.0)
    }
}

#Preview {
    CanteenCard()
}
