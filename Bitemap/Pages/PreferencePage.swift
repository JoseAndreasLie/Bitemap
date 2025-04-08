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
    @State private var tags: [String] = []
    @State private var selectedTags: [String] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Text("What do you like?")
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .bold()
                        .padding()
                    
                    tagGrid
                    
                    Spacer()
                    
                    Button("Save Preferences") {
                        userPreference = selectedTags.map { tag in
                            UserPreferencesModel(tag: tag, count: 2)
                        }
                        
                        // Encode and store
                        if let encoded = try? JSONEncoder().encode(userPreference) {
                            UserDefaults.standard.set(encoded, forKey: "userPreferences")
                        }
                        
//                        print("Saved user preferences: \(userPreference)")
                        onFinish()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding(4)
            }
            .padding(/*@START_MENU_TOKEN@*/.all, 4.0/*@END_MENU_TOKEN@*/)
            .navigationTitle("Preferences")
        }
        .onAppear{
            loadTagsFromJSON()
        }
//        .onChange(of: selectedTags) {
//            print("\n\n")
//            print("Selected Tags:", selectedTags)
//            print("Available Tags:", tags)
//        }
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
    
    
    private func loadTagsFromJSON() {
        if let url = Bundle.main.url(forResource: "DummyData", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let kantins = try? JSONDecoder().decode([Kantin].self, from: data) {
            
            let allTags = kantins.flatMap { $0.tags.map { $0.name } }
            tags = Array(Set(allTags)).sorted()
        } else {
            print("Failed to load or parse kantin_data.json")
        }
    }
}

#Preview {
    PreferencePage(onFinish: {})
}
