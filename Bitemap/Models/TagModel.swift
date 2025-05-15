//
//  TagModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 15/05/25.
//

import Foundation

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
