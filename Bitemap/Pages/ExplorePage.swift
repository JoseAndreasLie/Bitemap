//
//  explore.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct MyItem: Identifiable {
    let id = UUID() // or any unique identifier
    let name: String
}

let myItems = [MyItem(name: "Apple"), MyItem(name: "Banana")]

struct ExplorePage: View {
    var canteenNames: [String] = ["Kasturi", "Kartika", "Sari", "Ayam", "ASU", "goreng", "tepung"]
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    ForEach(canteenNames, id:\.self){canteenName in
                        NavigationLink(destination: CanteenPage(canteenName: canteenName)){
                            CanteenCard(canteenName: canteenName, locationName:"GOP 2", description: "Kasturi adalah sebuah makanan yang berasal dari daerah Sumatera Utara", image: "")
                            
                                .padding(.vertical, 4)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }.padding()
        }
        
    }
}

#Preview {
    ExplorePage()
}
