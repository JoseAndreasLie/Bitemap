//
//  UserPreferencesModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 07/04/25.
//

import Foundation

struct UserPreferencesModel: Identifiable, Codable{
    var id = UUID()
    var tag: String
    var count: Int
}
