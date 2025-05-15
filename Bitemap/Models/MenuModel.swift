//
//  UserModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 25/03/25.
//

//import Foundation
import SwiftUI

struct Menu: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let nama: String
    let category: String
    let price: Double
}
