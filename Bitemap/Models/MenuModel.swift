//
//  UserModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 25/03/25.
//

//import Foundation
import SwiftUI

struct Location: Codable, Equatable, Hashable {
    let id: String
    let name: String
    let images: [String] // Array gambar, urut sesuai step
    let desc: [String] // Array deskripsi, harus sama jumlahnya dengan images
    let long: Double
    let lat: Double
}

struct Tag: Codable, Identifiable, Hashable {
    let id: String
    let name: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Menu: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let nama: String
    let category: String // Gunakan String dulu kalau enum error
    let price: Double
}

enum MenuCategory: String, Codable, CaseIterable {
    case nasi, kentang, mie, ayam, daging, ikan, indonesia, western, japanese
}
