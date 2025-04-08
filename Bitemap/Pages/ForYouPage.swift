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
    
    private func score(for kantin: Kantin) -> Int {
        kantin.tags.reduce(0) { total, tag in
            total + (userPreferences.first(where: { $0.tag == tag.name })?.count ?? 0)
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    let sortedKantins = viewModel.filteredKantins.sorted { kantin1, kantin2 in
                        score(for: kantin1) > score(for: kantin2)
                    }
                    let topKantins = Array(sortedKantins.prefix(6))
                    
                    ForEach(topKantins, id: \.id) { kantin in
                        NavigationLink(destination: CanteenPage(kantin: kantin)) {
                            ForYouCardView(
                                name: kantin.nama,
                                location: kantin.location.name,
                                tags: kantin.tags.map { $0.name }
                            )
                        }
                        .padding(.all, 4.0)
                    }
                }
            }
            .padding(.all)
            .navigationTitle("For You")
        }
        .onAppear {
            loadUserPreferences()
        }
    }
    
    private func loadUserPreferences() {
        if let data = UserDefaults.standard.data(forKey: "userPreferences"),
           let decoded = try? JSONDecoder().decode([UserPreferencesModel].self, from: data) {
            userPreferences = decoded
//            print("Loaded user preferences:", userPreferences)
            
            // Convert to Tag and inject into viewModel
            let selected = Set(decoded.map { Tag(id: $0.tag, name: $0.tag) })
            viewModel.selectedTags = selected
        } else {
//            print("No user preferences found")
        }
    }
}

#Preview {
    ForYouPage()
}
