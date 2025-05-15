//
//  FavoriteViewModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 15/05/25.
//

import Foundation
import SwiftUI
import Combine

final class FavoriteViewModel: ObservableObject {
    @Published var canteens: [Canteen] = []
    @Published var likedCanteens: Set<String> = []
    @Published var sortOrder: SortOrder = .alphabetical
    
    enum SortOrder {
        case alphabetical
        case location
    }
    
    init() {
        loadCanteens()
        loadLikedCanteens()
    }
    
    func loadCanteens() {
        if let loadedCanteens = JsonLoader.load([Canteen].self, from: "DummyData") {
            self.canteens = loadedCanteens
        } else {
            print("Failed to load canteen data")
        }
    }
    
    var favoriteCanteens: [Canteen] {
        let filtered = canteens.filter { canteen in
            likedCanteens.contains(canteen.nama)
        }
        
        switch sortOrder {
        case .alphabetical:
            return filtered.sorted { $0.nama < $1.nama }
        case .location:
            return filtered.sorted { $0.location.name < $1.location.name }
        }
    }
    
    func updateLikedStatus(canteenName: String, isLiked: Bool) {
        if isLiked {
            likedCanteens.insert(canteenName)
        } else {
            likedCanteens.remove(canteenName)
        }
        
        saveLikedCanteens()
    }
    
    private func loadLikedCanteens() {
        let defaults = UserDefaults.standard
        likedCanteens = Set(defaults.stringArray(forKey: "likedCanteens") ?? [])
    }
    
    private func saveLikedCanteens() {
        let defaults = UserDefaults.standard
        defaults.set(Array(likedCanteens), forKey: "likedCanteens")
    }
    
    func refreshCanteens() async {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        loadCanteens()
    }
    
    func sortFavorites() {
        // Toggle between alphabetical and location sorting
        sortOrder = sortOrder == .alphabetical ? .location : .alphabetical
    }
}
