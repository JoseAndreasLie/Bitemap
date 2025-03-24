//
//  explore.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct Explore: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination:
                Canteen()
                .navigationBarTitle(Text("Detail"))
            ) {
                ScrollView() {
                    CanteenCard()
                    CanteenCard()
                    CanteenCard()
                    CanteenCard()
                    CanteenCard()
                    CanteenCard()
                    CanteenCard()
                    CanteenCard()
                    CanteenCard()
                }
                .padding(.horizontal)
                .scrollIndicators(.hidden, axes: [.vertical, .horizontal])
                .background(Color.gray.opacity(0.1))
            }.navigationBarTitle(Text("Explore"))
        }
    }
}

#Preview {
    Explore()
}
