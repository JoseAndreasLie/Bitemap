//
//  UserModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 25/03/25.
//

import Foundation

struct CanteenModel: Identifiable, Codable {
    var id = UUID()
    var name: String
    var menus: [MenuModel]
    
    // Custom initialization from dictionary of menus
    init(name: String, menuDict: [String: [String: Any]]) {
        self.name = name
        self.menus = []
        
        // Parse the menus
        for (_, menuData) in menuDict {
            if let menuDict = menuData as? [String: Any],
               let name = menuDict["name"] as? String,
               let price = menuDict["price"] as? Int,
               let tagsDict = menuDict["Tags"] as? [String: Any],
               let cuisine = tagsDict["cuisine"] as? [String],
               let nutritionalDict = tagsDict["nutritional"] as? [String: Any],
               let protein = nutritionalDict["protein"] as? [String],
               let carbs = nutritionalDict["carbs"] as? [String] {
                
                let nutritional = NutritionalModel(protein: protein, carbs: carbs)
                let tags = TagsModel(cuisine: cuisine, nutritional: nutritional)
                let menu = MenuModel(name: name, price: price, tags: tags)
                menus.append(menu)
            }
        }
    }
}
