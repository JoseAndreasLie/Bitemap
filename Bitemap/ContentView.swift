//
//  ContentView.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 21/03/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView(
            selection: /*@START_MENU_TOKEN@*/ /*@PLACEHOLDER=Selection@*/
            .constant(1) /*@END_MENU_TOKEN@*/
        ) {
            ForYouPage() // ada di folder ./Pages/forYou.swift
                .tabItem {
                    Label("Kantin", systemImage: "list.dash")
                }
                .tag(1)
            ExplorePage() // ada di folder ./Pages/explore.swift
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
