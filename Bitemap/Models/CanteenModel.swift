//
//  UserModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 25/03/25.
//

import SwiftUI

struct Kantin: Codable, Identifiable, Hashable {
    let id: String
    let nama: String
    let location: Location
    let tags: [Tag] // Menggunakan array, bukan Set
    let menu: [Menu]
}
