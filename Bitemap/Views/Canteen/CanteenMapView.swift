//
//  KantinMapView.swift
//  Bitemap
//
//  Created by Lin Dan Christiano on 27/03/25.
//

import SwiftUI
import MapKit

struct CanteenMapView: View {
    let canteen: Canteen

    var body: some View {
        VStack {
            Text("Direction to \(canteen.nama)")
                .font(.headline)
                .padding()

            List {
                ForEach(Array(zip(canteen.location.images, canteen.location.desc)), id: \.0) { (image, desc) in
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
