//
//  PreferencePage.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 28/03/25.
//

import SwiftUI

struct PreferencePage: View {
    var onFinish: () -> Void
    
    @State private var userPreference: [UserPreferencesModel] = []
    @State private var tags: [String] = ["Rice", "Indonesia", "Chicken", "Beef", "Noodle", "Potato", "Fish", "Japanese", "Egg"]
    @State private var selectedTags: [String] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("What do you like?")
                        .font(.headline)
                        .bold()
                        .padding()
                    
                    tagGrid
                    
                    Button("Save Preferences") {
                        userPreference = selectedTags.map { tag in
                            UserPreferencesModel(tag: tag, count: 2)
                        }
                        
                        // Encode and store
                        if let encoded = try? JSONEncoder().encode(userPreference) {
                            UserDefaults.standard.set(encoded, forKey: "userPreferences")
                        }
                        
                        print("Saved user preferences: \(userPreference)")
                        onFinish()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding(4)
            }
            .navigationTitle("Preferences")
        }
        .onChange(of: selectedTags) {
            print("\n\n\n\n\n")
            print("Selected Tags:", selectedTags)
            print("Available Tags:", tags)
        }
    }

    private var tagGrid: some View {
        let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
        
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(tags, id: \.self) { tag in
                PreferenceButton(
                    isSelected: selectedTags.contains(tag),
                    title: tag,
                    action: {
                        toggleTag(tag)
                    }
                )
            }
        }
    }
    
    private func toggleTag(_ tag: String) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
    }
}

#Preview {
    PreferencePage(onFinish: {
        print("Pindah Page")
    })
}
