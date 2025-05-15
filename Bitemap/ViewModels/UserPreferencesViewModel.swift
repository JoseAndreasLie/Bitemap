//
//  UserPreferencesViewModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 15/05/25.
//

import Foundation
import SwiftUI
import Combine

final class PreferenceViewModel: ObservableObject {
    @Published var tags: [String] = []
    @Published var selectedTags: [String] = []
    
    private let preferencesService: UserPreferencesService
    
    init(preferencesService: UserPreferencesService = UserPreferencesService()) {
        self.preferencesService = preferencesService
        loadTagsFromJSON()
    }
    
    func loadTagsFromJSON() {
        if let kantins = JsonLoader.load([Canteen].self, from: "DummyData") {
            let allTags = kantins.flatMap { $0.tags.map { $0.name } }
            tags = Array(Set(allTags)).sorted()
        } else {
            print("Failed to load or parse Canteen data")
        }
    }
    
    func toggleTag(_ tag: String) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
    }
    
    func savePreferences(completion: @escaping () -> Void) {
        let preferences = selectedTags.map { tag in
            UserPreferencesModel(tag: tag, count: 2)
        }
        
        preferencesService.savePreferences(preferences)
        completion()
    }
}
