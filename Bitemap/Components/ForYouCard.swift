//
//  ForYouCard.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import SwiftUI

struct ForYouCardView: View {
    let name: String
    let location: String
    let tags: [String]
    let image: String
    
    var body: some View {
        VStack(alignment: .leading) {
            if UIImage(named: image) != nil {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                    .clipped()
            } else {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(.gray)
            }
            Group{
                HStack {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Image(systemName: "mappin.and.ellipse") // Ikon lokasi
                        .foregroundColor(.green)
                    
                    Text(location)
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                //            .padding(5)
                ChipLabelView(tags: tags)
            }
            .padding(.horizontal, 10)
        }
        .frame(width: 180, height: 180)
        .padding(.bottom, 5)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

//// PREVIEW
//struct ForYouCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForYouCardView(
//            name: "Kasturi",
//            location: "GOP 9",
//            tags: ["Rice", "Indonesia", "Beef", "Chicken"]
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
//
