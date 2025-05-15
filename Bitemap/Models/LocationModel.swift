//
//  LocationModel.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 15/05/25.
//

import Foundation

struct Location: Codable, Equatable, Hashable {
    let id: String
    let name: String
    let images: [String] // Array gambar, urut sesuai step
    let desc: [String] // Array deskripsi, harus sama jumlahnya dengan images
    let long: Double
    let lat: Double
}
