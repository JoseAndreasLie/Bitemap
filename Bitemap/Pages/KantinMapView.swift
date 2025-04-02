//
//  KantinMapView.swift
//  Bitemap
//
//  Created by Lin Dan Christiano on 27/03/25.
//


//
//  KantinMapView.swift
//  BitemapLearnTesting
//
//  Created by Lin Dan Christiano on 26/03/25.
//

import SwiftUI
import MapKit

struct CanteenMapView: View {
    let kantin: Kantin

    var body: some View {
        VStack {
            Text("Cara Menuju \(kantin.nama)")
                .font(.headline)
                .padding()

            List {
                ForEach(Array(zip(kantin.location.images, kantin.location.desc)), id: \.0) { (image, desc) in
                    VStack {
                        Image(image) // Pastikan gambarnya ada di Assets
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                        Text(desc)
                            .font(.caption)
                            .padding()
                    }
                }
            }
        }
    }
}
