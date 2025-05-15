//
//  FavoritePage.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 14/05/25.
//

import Foundation
import SwiftUI

struct FavoritePage: View {
    @State private var isLiked = true

    var body: some View {
        
        
        LongCard(title: "Favorite", location: "GOP 6", image: "DapurKencana", tags: ["Anjing", "Kucing", "Babi", "Binatang"], isLiked: $isLiked)
    }
}

#Preview {
    FavoritePage()
}
