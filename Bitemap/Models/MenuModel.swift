//
//  UserModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 25/03/25.
//

import Foundation

struct MenuModel: Identifiable, Codable {
    var id = UUID()
    var name: String
    var price: Int
    var tags: TagsModel
    
    enum CodingKeys: String, CodingKey {
        case name
        case price
        case tags = "Tags"
    }
}

struct TagsModel: Codable {
    var cuisine: [String]
    var nutritional: NutritionalModel
}

struct NutritionalModel: Codable {
    var protein: [String]
    var carbs: [String]
}
