//
//  LongCard.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 14/05/25.
//

import Foundation
import SwiftUI

struct LongCard: View {
    let title: String
    let location: String
    let image: String
    let tags: [String]
    @Binding var isLiked: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120, alignment: .center)
                .background(Color(red: 0.84, green: 0.84, blue: 0.84))
                .cornerRadius(16)
            VStack(alignment: .leading) {
                // Space Between
                HStack(alignment: .top) {
                    // Space Between
                    VStack(alignment: .leading, spacing: 8) {
                        Text(title)
                            .font(
                                Font.custom("SF Pro", size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                        HStack(alignment: .top) {
                            Image(systemName: "mappin.and.ellipse.circle")
                            Text(location)
                        }
                        .font(Font.custom("SF Pro", size: 12))
                        .foregroundColor(
                            Color(red: 0.19, green: 0.19, blue: 0.19))
                    }

                    .padding(0)
                    Spacer()
                    // Make heart button clickable
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(8)
                            .foregroundStyle(isLiked ? .red : .black)
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(0)
                .frame(maxWidth: .infinity, alignment: .top)
                Spacer()
                // Alternating Views and Spacers
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(tags, id: \.self) { tag in
                            ChipTag(tag: tag)
                        }
                    }
                }
                .frame(width: 216, alignment: .leading)
            }
            .padding(8)
            .frame(
                minWidth: 224, maxWidth: 224, maxHeight: .infinity,
                alignment: .leading
            )
            .cornerRadius(16)
        }
        .frame(
            minWidth: 330, maxWidth: 370, minHeight: 110, maxHeight: 140,
            alignment: .center
        )
        .padding(8)
        .background(Color(red: 0.99, green: 0.97, blue: 0.89))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 4)
    }
}

#Preview {
    LongCard(
        title: "Kasturi",
        location: "GOP 6",
        image: "Kasturi",
        tags: ["Vegan", "Spicy", "Halal", "Chicken"],
        isLiked: .constant(false)
    )
}
