//
//  ForYouCard.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct CanteenCard: View {
    @State var canteenName: String
    @State var image: String
    @State var tags: [Tag]
    @State var location: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 110, height: 110)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(canteenName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(Color("CustomGreen"))
                            .font(.system(size: 14))
                        
                        Text(location)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color("CustomGreen"))
                    }
                }
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                ChipLabelView(tags: tags.map { $0.name })
                
                Spacer()
                
                HStack {
                    Spacer()
                    HStack {
                        Text("See Menu")
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color("CustomOrange"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: Color("CustomOrange").opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(.trailing, 4)
            .frame(height: 140)
        }
        .padding(12)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}
