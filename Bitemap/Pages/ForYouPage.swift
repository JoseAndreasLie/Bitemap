//
//  forYou.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct ForYouPage: View {
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @State private var userPreferences: [UserPreferencesModel] = []
    @StateObject private var viewModel = KantinViewModel()
    @State private var showingPreferences = false
    @State private var showingConfirmation = false
    
    private func score(for kantin: Kantin) -> Int {
        kantin.tags.reduce(0) { total, tag in
            total + (userPreferences.first(where: { $0.tag == tag.name })?.count ?? 0)
        }
    }
    
    var topKantins: [Kantin] {
        let sorted = viewModel.filteredKantins.sorted { score(for: $0) > score(for: $1) }
        return Array(sorted.prefix(6))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Add this subtle background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor.systemBackground),
                        Color("CustomGreen").opacity(0.3)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(topKantins, id: \.id) { kantin in
                                KantinCard(kantin: kantin)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Reset Preferences Button moved to bottom
                        Button(action: {
                            showingConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Reset Preferences")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color("CustomGreen"),
                                        Color("CustomGreen").opacity(0.8)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: Color("CustomGreen").opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .padding(.vertical, 120)
                    }
                }
                .padding(.horizontal, 8.0)
                .navigationTitle("For You")
            }
        }
        .onAppear {
            loadUserPreferences()
        }
        .fullScreenCover(isPresented: $showingPreferences) {
            PreferencePage {
                showingPreferences = false
                // Reload preferences when returning from the preferences page
                loadUserPreferences()
            }
        }
        .alert("Reset Preferences", isPresented: $showingConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                showingPreferences = true
            }
        } message: {
            Text("Are you sure you want to reset your food preferences?")
        }
    }
    
    private func loadUserPreferences() {
        if let data = UserDefaults.standard.data(forKey: "userPreferences"),
           let decoded = try? JSONDecoder().decode([UserPreferencesModel].self, from: data) {
            userPreferences = decoded
            print("\n\nLoaded user preferences:", userPreferences)
            
            // Convert to Tag and inject into viewModel
            let selected = Set(decoded.map { Tag(id: $0.tag, name: $0.tag) })
            viewModel.selectedTags = selected
        } else {
            print("No user preferences found")
        }
    }
}

struct KantinCard: View {
    let kantin: Kantin

    var body: some View {
        NavigationLink(destination: CanteenPage(kantin: kantin)) {
            ForYouCardView(
                name: kantin.nama,
                location: kantin.location.name,
                tags: kantin.tags.map { $0.name },
                image: kantin.location.images.last ?? "map"
            )
            .padding(/*@START_MENU_TOKEN@*/.vertical, 8.0)
        }
    }
}

#Preview {
    ForYouPage()
}
