//
//  KantinViewModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 15/05/25.
//

import Foundation

final class ForYouViewModel: ObservableObject {
    
    @Published var canteens: [Canteen] = []
    @Published var userPreferences: [UserPreferencesModel] = []
    
    private let preferencesService: UserPreferencesService
    
    init(preferencesService: UserPreferencesService = UserPreferencesService()) {
        self.preferencesService = preferencesService
        self.loadCanteens()
        self.loadUserPreferences()
    }
    
    func loadCanteens() {
        if let loadedCanteens = JsonLoader.load([Canteen].self, from: "DummyData") {
            self.canteens = loadedCanteens
        } else {
            print("Failed to load canteen data")
        }
    }
    
    func loadUserPreferences() {
        if let preferences = preferencesService.loadPreferences() {
            self.userPreferences = preferences
            print("Loaded user preferences:", preferences)
        } else {
            print("No user preferences found")
        }
    }
    
    // Compute a score for each canteen based on user preferences
    private func score(for canteen: Canteen) -> Int {
        canteen.tags.reduce(0) { total, tag in
            total + (userPreferences.first(where: { $0.tag == tag.name })?.count ?? 0)
        }
    }
    
    // Return canteens sorted by preference score
    var recommendedCanteens: [Canteen] {
        canteens.sorted { score(for: $0) > score(for: $1) }
    }
    
    // Return top 6 recommended canteens for the "For You" view
    var topRecommendedCanteens: [Canteen] {
        Array(recommendedCanteens.prefix(6))
    }
    
    // Track user interactions to improve recommendations
    func incrementTagCount(for tagName: String) {
        if let index = userPreferences.firstIndex(where: { $0.tag == tagName }) {
            var updatedPreference = userPreferences[index]
            updatedPreference.count += 1
            userPreferences[index] = updatedPreference
            savePreferences()
        }
    }
    
    // Add a canteen to favorites for a specific tag
    func addToFavorites(canteenName: String, for tagName: String) {
        if let index = userPreferences.firstIndex(where: { $0.tag == tagName }) {
            var updatedPreference = userPreferences[index]
            var favorites = updatedPreference.favoriteCanteenNames ?? []
            if !favorites.contains(canteenName) {
                favorites.append(canteenName)
                updatedPreference.favoriteCanteenNames = favorites
                userPreferences[index] = updatedPreference
                savePreferences()
            }
        }
    }
    
    // Save the current state of user preferences
    private func savePreferences() {
        preferencesService.savePreferences(userPreferences)
    }
    
    func refreshCanteens() async {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        loadCanteens() // or your existing reload method
    }
}
