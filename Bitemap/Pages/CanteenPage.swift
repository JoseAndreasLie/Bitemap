//
//  Canteen.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

//import SwiftUI
//
//struct CanteenPage: View {
//    let kantin: Kantin
//    @State private var showMap = false
//
//    var body: some View {
//        VStack {
//            List(kantin.menu) { menu in
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text(menu.nama)
//                            .font(.headline)
//                    }
//                    Spacer()
//                    Text("Rp \(Int(menu.price))")
//                }
//            }
//        }
//        .navigationTitle(kantin.nama)
//        .toolbar {
//            Button(action: {
//                showMap.toggle()
//            }) {
//                Image(systemName: "map")
//            }
//        }
//        .sheet(isPresented: $showMap) {
//            CanteenMapView(kantin: kantin)
//        }
//    }
//}

import SwiftUI

struct CanteenPage: View {
    let kantin: Kantin
    @State private var showMap = false

    var body: some View {
        VStack {
            List {
                // Mengelompokkan menu berdasarkan kategori
                ForEach(groupedMenuKeys(), id: \.self) { category in
                    Section(header: Text(category).font(.headline)) {
                        ForEach(groupedMenu()[category] ?? [], id: \.id) { menu in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(menu.nama)
                                        .font(.headline)
                                }
                                Spacer()
                                Text("Rp \(Int(menu.price))")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(kantin.nama)
        .toolbar {
            Button(action: {
                showMap.toggle()
            }) {
                Image(systemName: "map")
            }
        }
        .sheet(isPresented: $showMap) {
            CanteenMapView(kantin: kantin)
        }
    }

    // Fungsi untuk mengelompokkan menu berdasarkan kategori
    private func groupedMenu() -> [String: [Menu]] {
        Dictionary(grouping: kantin.menu) { $0.category }
    }
    
    // Fungsi untuk mendapatkan kunci (kategori) yang sudah diurutkan
    private func groupedMenuKeys() -> [String] {
        groupedMenu().keys.sorted()
    }
}

#Preview {
    CanteenPage(kantin: Kantin(id: "1", nama: "Kantin A", location: Location(id: "loc1", name: "Gedung A", images: ["gedungA_1.jpg"], desc: ["Deskripsi lokasi"], long: 123.456, lat: -6.789), tags: [Tag(id: "t1", name: "Rice")], menu: [
        Menu(id: "m1", nama: "Nasi Goreng", category: "Makanan", price: 15000),
        Menu(id: "m2", nama: "Es Teh", category: "Minuman", price: 5000),
        Menu(id: "m3", nama: "Soto Ayam", category: "Makanan", price: 20000)
    ]))
}
