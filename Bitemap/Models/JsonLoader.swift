//
//  JsonLoader.swift
//  Bitemap
//
//  Created by Lin Dan Christiano on 27/03/25.
//

import SwiftUI
import Foundation

class KantinViewModel: ObservableObject {
    @Published var kantins: [Kantin] = []
    @Published var selectedTags: Set<Tag> = []
    @Published var availableTags: [Tag] = [
        Tag(id: "1", name: "nasi"),
        Tag(id: "2", name: "kentang"),
        Tag(id: "3", name: "mie"),
        Tag(id: "4", name: "ayam"),
        Tag(id: "5", name: "daging"),
        Tag(id: "6", name: "ikan"),
        Tag(id: "7", name: "indonesia"),
        Tag(id: "8", name: "western"),
        Tag(id: "9", name: "japanese")
    ]

    init() {
        self.kantins = loadKantinData()
    }

    var filteredKantins: [Kantin] {
        guard !selectedTags.isEmpty else { return kantins }
        return kantins.filter { kantin in
            !Set(kantin.tags.map { $0.name }).isDisjoint(with: selectedTags.map { $0.name })
        }
    }

    func toggleTagSelection(tag: Tag) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }

    func loadKantinData() -> [Kantin] {
        guard let url = Bundle.main.url(forResource: "DummyData", withExtension: "json") else {
            print("File JSON tidak ditemukan!")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let kantins = try JSONDecoder().decode([Kantin].self, from: data)
            return kantins
        } catch {
            print("Error loading JSON: \(error)")
            return []
        }
    }
    
    func setSelectedTags(tags: [String]) {
        selectedTags = Set(availableTags.filter { tags.contains($0.name) })
    }
}


