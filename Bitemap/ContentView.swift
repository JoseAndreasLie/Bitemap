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
            forYou() // ada di folder ./Pages/forYou.swift
                .tabItem {
                    Text("For You")
                }
                .tag(1)
            explore() // ada di folder ./Pages/explore.swift
                .tabItem {
                    Text("Explore")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
}
