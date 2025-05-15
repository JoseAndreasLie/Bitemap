//
//  LongCard.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 14/05/25.
//

import SwiftUI

struct LongCard: View {
    let title: String
    let location: String
    let image: String
    let tags: [String]
    @Binding var isLiked: Bool
    @State private var heartPressed = false
    @Environment(\.colorScheme) var colorScheme
    
    // Dynamic colors based on color scheme
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(UIColor.systemBackground) : Color(red: 0.99, green: 0.98, blue: 0.95)
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.4) : Color.black.opacity(0.15)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Image with overlay gradient
            ZStack(alignment: .bottomLeading) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .clipped()
                    .overlay(
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(
                                LinearGradient(
                                    colors: [.clear, .black.opacity(0.3)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .cornerRadius(16)
                
                // Location pill directly on the image
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 10))
                    Text(location)
                        .font(.system(size: 10, weight: .medium))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Title and heart button
                HStack(alignment: .top) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Heart button with animation
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            heartPressed = true
                            isLiked.toggle()
                        }
                        
                        // Reset the animation state
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            heartPressed = false
                        }
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(isLiked ? .red : .gray)
                            .frame(width: 32, height: 32)
                            .contentShape(Rectangle())
                            .scaleEffect(heartPressed ? 1.3 : 1.0)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                
                Spacer()
                
                // Tags in horizontal scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(tags.prefix(4), id: \.self) { tag in
                            ChipTag(tag: tag)
                        }
                        
                        if tags.count > 4 {
                            Text("+\(tags.count - 4)")
                                .font(.system(size: 10, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color("CustomGreen").opacity(0.2))
                                .foregroundColor(Color("CustomGreen"))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .frame(height: 100)
            .padding(.vertical, 10)
        }
        .padding(12)
        .background(cardBackgroundColor)
        .cornerRadius(20)
        .shadow(color: shadowColor, radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.1), lineWidth: 0.5)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        LongCard(
            title: "Kasturi Restaurant",
            location: "GOP 6",
            image: "Kasturi",
            tags: ["Vegan", "Spicy", "Halal", "Chicken"],
            isLiked: .constant(false)
        )
        
        LongCard(
            title: "D'Padang",
            location: "Building B",
            image: "map",
            tags: ["Rice", "Spicy", "Halal"],
            isLiked: .constant(true)
        )
    }
    .padding()
    .background(Color(UIColor.systemGray6))
}
