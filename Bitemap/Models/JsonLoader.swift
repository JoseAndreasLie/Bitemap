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
}


