//
//  KantinMapView.swift
//  Bitemap
//
//  Created by Lin Dan Christiano on 27/03/25.
//

import SwiftUI
import MapKit

struct CanteenMapView: View {
    let kantin: Kantin

    var body: some View {
        VStack {
            Text("Direction to \(kantin.nama)")
                .font(.headline)
                .padding()

            List {
                ForEach(Array(zip(kantin.location.images, kantin.location.desc)), id: \.0) { (image, desc) in
                    HStack{
                        VStack(alignment: .leading, spacing: 10){
                            Circle()
                                .fill(.orange)
                                .frame(width: 15, height: 15)
                            Rectangle()
                                .fill(.orange)
                                .frame(width: 1)
                                .padding(.leading, 6)
                                .padding(.top, 0)
                        }
                        HStack {
                            Image(image)
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
}
