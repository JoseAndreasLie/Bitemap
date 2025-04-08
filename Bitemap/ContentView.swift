//
//  ContentView.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 21/03/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenPreferences") private var hasSeenPreferences = false
    var body: some View {
        if !hasSeenPreferences {
            PreferencePage(
                onFinish: {
                    hasSeenPreferences = true
                }
            ).onAppear{
                print("Has Seen Preferences:", hasSeenPreferences)
            }
        } else {
            TabView {
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
            }.onAppear{
                print("Has Seen Preferences:", hasSeenPreferences)
            }
        }
    }
}

#Preview {
    ContentView()
        .onAppear {
        #if DEBUG
        UserDefaults.standard.removeObject(forKey: "hasSeenPreferences")
        #endif
    }
}
