//
//  explore.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct MyItem: Identifiable {
    let id = UUID() // or any unique identifier
    let name: String
}

let myItems = [MyItem(name: "Apple"), MyItem(name: "Banana")]

struct ExplorePage: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination:
                            CanteenPage()
                .navigationBarTitle(Text("Detail"))
            ) {
                ScrollView() {
                    // bisa pakek VStack() buat pastiin dia atas bawah :>
                    ForEach(nama){ nama in
                        CanteenCard(name: nama).padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)
                .scrollIndicators(.hidden, axes: [.vertical])
            }.navigationBarTitle(Text("Explore"))
        }
        
    }
}

#Preview {
    ExplorePage()
}
