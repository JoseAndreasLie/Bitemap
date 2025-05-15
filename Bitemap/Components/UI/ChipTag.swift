//
//  ChipTag.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 14/05/25.
//

import Foundation
import SwiftUI

struct ChipTag: View {
    // Core content
    let tag: String
    
    
    
    // Customization options
    var isSelected: Bool = false
    var isRemovable: Bool = false
    var onRemove: (() -> Void)? = nil
    var onTap: (() -> Void)? = nil
    
    // Styling options with defaults matching original design
    var textColor: Color = Color(red: 0.03, green: 0.33, blue: 0.09)
    var selectedTextColor: Color = Color.white
    var backgroundColor: Color = Color(red: 0.95, green: 0.96, blue: 0.95)
    var selectedBackgroundColor: Color = Color(red: 0.03, green: 0.33, blue: 0.09)
    var borderColor: Color = Color(red: 0.03, green: 0.33, blue: 0.09)
    var fontSize: CGFloat = 12
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 4
    var cornerRadius: CGFloat = 16
    
    @State private var isPressed: Bool = false
    @State private var opacity: Double = 1.0
    
    // Animation properties
    @Namespace private var chipAnimation
    
    var body: some View {
        HStack(spacing: 4) {
            Text(tag)
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(isSelected ? selectedTextColor : textColor)
                .matchedGeometryEffect(id: "tagText", in: chipAnimation)
                .accessibilityLabel(tag)
            
            if isRemovable {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        opacity = 0
                        
                        // Add small delay before executing onRemove
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onRemove?()
                        }
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: fontSize))
                        .foregroundColor(isSelected ? selectedTextColor.opacity(0.8) : textColor.opacity(0.8))
                }
                .accessibilityLabel("Remove \(tag) tag")
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isSelected ? selectedBackgroundColor : backgroundColor)
                .matchedGeometryEffect(id: "background", in: chipAnimation)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .inset(by: 0.5)
                .stroke(borderColor, lineWidth: isPressed ? 1.5 : 1)
                .matchedGeometryEffect(id: "border", in: chipAnimation)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .opacity(opacity)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            // Press animation
            withAnimation {
                isPressed = true
            }
            
            // Release animation with a slight delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isPressed = false
                }
                onTap?()
            }
        }
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : [.isButton])
    }
}

// MARK: - Previews
struct ChipTag_Previews: PreviewProvider {
    static var tags = ["Trending", "Popular", "Vegan", "Dessert", "Fast Food"]
    
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Basic
                HStack {
                    ChipTag(tag: "Regular Tag")
                    ChipTag(tag: "Selected Tag", isSelected: true)
                }
                
                // Removable
                HStack {
                    ChipTag(tag: "Removable", isRemovable: true)
                    ChipTag(tag: "Selected & Removable", isSelected: true, isRemovable: true)
                }
                
                // Custom colors
                HStack {
                    ChipTag(tag: "Custom Colors",
                            textColor: .blue,
                            selectedTextColor: .white,
                            backgroundColor: .blue.opacity(0.1),
                            selectedBackgroundColor: .blue,
                            borderColor: .blue)
                }
                
                // Different sizes
                HStack {
                    ChipTag(tag: "Small",
                            fontSize: 10,
                            horizontalPadding: 12,
                            verticalPadding: 2,
                            cornerRadius: 12)
                    
                    ChipTag(tag: "Large",
                            fontSize: 14,
                            horizontalPadding: 20,
                            verticalPadding: 6,
                            cornerRadius: 20)
                }
                
                // Row of tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            ChipTag(tag: tag, isSelected: tag == "Popular")
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
    }
}
