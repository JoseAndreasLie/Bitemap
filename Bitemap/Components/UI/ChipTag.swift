//
//  ChipTag.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 14/05/25.
//

import Foundation
import SwiftUI

struct ChipTag: View {
    let tag: String
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(tag)
              .font(Font.custom("SF Pro", size: 12))
              .foregroundColor(Color(red: 0.03, green: 0.33, blue: 0.09))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(Color(red: 0.95, green: 0.96, blue: 0.95))
        .cornerRadius(16)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .inset(by: 0.5)
            .stroke(Color(red: 0.03, green: 0.33, blue: 0.09), lineWidth: 1)
        )
    }
}

#Preview {
    ChipTag(tag: "Yahooo")
}

