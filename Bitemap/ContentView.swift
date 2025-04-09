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
                    Label("For You", systemImage: selectedTab == 1 ? "heart.fill" : "heart")
                }
                .tag(1)
            
            ExplorePage()
                .tabItem {
                    Label("Explore", systemImage: selectedTab == 2 ? "map.fill" : "map")
                }
                .tag(2)
        }
        .tint(Color("CustomGreen")) // Use your CustomGreen for the selected tab
        .onAppear {
            // Set the TabBar appearance globally
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            // Explicitly disable the separator/stroke
            appearance.shadowColor = .clear
            appearance.shadowImage = UIImage()
            
            // Apply the same appearance to both standard and scrollEdge states
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .animation(.easeInOut(duration: 0.2), value: selectedTab)
    }
}

#Preview {
    ContentView()
        .onAppear {
//        #if DEBUG
//        UserDefaults.standard.removeObject(forKey: "hasSeenPreferences")
//        #endif
    }
}
