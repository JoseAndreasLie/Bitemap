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
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}
