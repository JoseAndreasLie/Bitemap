//
//  UserModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 25/03/25.
//

import SwiftUI

struct Canteen: Codable, Identifiable, Hashable {
    let id: String
    let nama: String
    let location: Location
    let tags: [Tag]
    let menu: [Menu]
}
