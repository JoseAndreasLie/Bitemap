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
        VStack(alignment: .leading, spacing: 8) {
            if UIImage(named: image) != nil {
                ZStack(alignment: .bottomLeading) {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.white)
                        Text(location)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(8)
                }
                .cornerRadius(12)
                
            } else {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                ChipLabelView(tags: tags)
            }
            .padding([.leading, .bottom, .trailing], 8)
        }
        .frame(width: 170)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), 
                radius: 5, 
                x: 0, 
                y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    ForYouCardView(name: "John Doe", location: "Jakarta", tags: ["travel","food","travel", "food","travel", "food"], image: "person.circle")
}
