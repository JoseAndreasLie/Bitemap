//
//  Canteen.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

public struct CanteenPage: View {
    var canteenName: String
    public var body: some View {
        Text("Ini masuk kantin \(canteenName)")
            .navigationBarTitle(Text(canteenName))
        CanteenCard(canteenName: "Kasturi", locationName:"GOP 2", description: "Kasturi adalah sebuah makanan yang berasal dari daerah Sumatera Utara", image: "")
    }
}

#Preview {
    CanteenPage(canteenName: "apala")
}
