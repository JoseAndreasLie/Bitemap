//
//  PreferenceButton.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 07/04/25.
//

import Foundation
import SwiftUI

struct PreferenceButton: View {
    let isSelected: Bool
    let title: String
    let action: () -> Void
    @State private var isPressing = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(minWidth: 100)
                .background(
                    isSelected ? 
                        Color("CustomGreen") : 
                        Color.gray.opacity(0.12)
                )
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
                .shadow(
                    color: isSelected ? Color("CustomGreen").opacity(0.3) : Color.clear, 
                    radius: isPressing ? 2 : 4, 
                    x: 0, 
                    y: isPressing ? 1 : 2
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .scaleEffect(isPressing ? 0.97 : 1)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
                .animation(.easeInOut(duration: 0.1), value: isPressing)
        }
        .pressEvents(onPress: { isPressing = true }, onRelease: { isPressing = false })
    }
}

// Add this extension to handle press events
extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEffectViewModifier(onPress: onPress, onRelease: onRelease))
    }
}

struct PressEffectViewModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}
