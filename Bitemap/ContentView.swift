//
//  ContentView.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 21/03/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenPreferences") private var hasSeenPreferences = false
    @State private var isTransitioning = false
    
    var body: some View {
        ZStack {
            if !hasSeenPreferences {
                PreferencePage(
                    onFinish: {
                        withAnimation(.easeInOut(duration: 0.7)) {
                            isTransitioning = true
                        }
                        
                        // Delay setting hasSeenPreferences to allow animation to complete
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            hasSeenPreferences = true
                            isTransitioning = false
                        }
                    }
                )
                .transition(.asymmetric(
                    insertion: .opacity,
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            } else {
                MainTabView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
        }
        .animation(.easeInOut(duration: 0.7), value: hasSeenPreferences)
    }
}

// Extract the TabView to a separate view for cleaner organization
struct MainTabView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForYouPage()
                .tabItem {
                    Label("For You", systemImage: "list.dash")
                }
                .tag(1)
            
            ExplorePage()
                .tabItem {
                    Label("Explore", systemImage: "magnifyingglass")
                }
                .tag(2)
        }
        .animation(.easeInOut, value: selectedTab)
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
