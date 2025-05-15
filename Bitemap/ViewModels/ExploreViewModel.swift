import Foundation
import SwiftUI
import Combine

final class ExploreViewModel: ObservableObject {
    @Published var canteens: [Canteen] = []
    @Published var selectedTags: Set<Tag> = []
    @Published var showFilterSheet: Bool = false
    
    // This is correct and efficient
    var filteredCanteens: [Canteen] {
        if selectedTags.isEmpty {
            return canteens
        } else {
            return canteens.filter { canteen in
                canteen.tags.contains { tag in
                    selectedTags.contains(tag)
                }
            }
        }
    }
    
    init() {
        loadCanteens()
    }
    
    func loadCanteens() {
        if let loadedCanteens = JsonLoader.load([Canteen].self, from: "DummyData") {
            self.canteens = loadedCanteens
        } else {
            print("Failed to load canteen data")
        }
    }
    
    func toggleTagSelection(tag: Tag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    func clearAllTags() {
        selectedTags.removeAll()
    }
    
    // Group tags by categories for displaying in filter sheet
    func getTagsByCategory() -> [String: [String]] {
        return [
            "Meal Time": ["Breakfast", "Lunch", "Dinner"],
            "Cuisine": ["Indonesia", "Chinese", "Western", "Japanese"],
            "Carbs": ["Rice", "Noodle", "Potato", "Bread"],
            "Proteins": ["Egg", "Chicken", "Duck", "Beef", "Seafood", "Pork", "Lamb"],
            "Others": ["Veggies", "Fruits"]
        ]
    }
    
    // Get all available tags from loaded canteens
    func getAllTags() -> [Tag] {
        var uniqueTags = Set<Tag>()
        for canteen in canteens {
            uniqueTags = uniqueTags.union(canteen.tags)
        }
        return Array(uniqueTags)
    }
    
    // Implementation for saving liked canteens
    func saveLikedCanteen(canteenName: String, isLiked: Bool) {
        // Store in UserDefaults for persistence
        let defaults = UserDefaults.standard
        var likedCanteens = Set(defaults.stringArray(forKey: "likedCanteens") ?? [])
        
        if isLiked {
            likedCanteens.insert(canteenName)
        } else {
            likedCanteens.remove(canteenName)
        }
        
        defaults.set(Array(likedCanteens), forKey: "likedCanteens")
    }
    
    // Load liked canteens from storage
    func getLikedCanteens() -> Set<String> {
        let defaults = UserDefaults.standard
        return Set(defaults.stringArray(forKey: "likedCanteens") ?? [])
    }
}
