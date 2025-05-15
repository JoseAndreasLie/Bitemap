//
//  ChipLabel.swift
//  Bitemap
//
//  Created by Lin Dan Christiano on 27/03/25.
//

import SwiftUI

struct ChipLabelView: View {
    let tags: [String]
    
    var body: some View {
        let maxTags = min(tags.count, 4)  // Limit to display no more than 4 tags
        let displayedTags = Array(tags.prefix(maxTags))
        
        return VStack(alignment: .leading, spacing: 4) {
            // Simple fixed layout instead of dynamic rows
            FlexibleView(
                data: displayedTags,
                spacing: 4,
                alignment: .leading
            ) { tag in
                Text(tag)
                    .font(.system(size: 10, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color("CustomGreen").opacity(0.15))
                    .foregroundColor(Color("CustomGreen"))
                    .cornerRadius(12)
            }
        }
        .frame(height: 50)
    }
}

// Simple flexible layout container without animations
struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    
    init(data: Data, spacing: CGFloat = 8, alignment: HorizontalAlignment = .center, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(generateRows(), id: \.self) { rowItems in
                HStack(spacing: spacing) {
                    ForEach(rowItems, id: \.self) { item in
                        content(item)
                    }
                }
            }
        }
    }
    
    private func generateRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        
        for item in data {
            if rows[currentRow].count < 2 {
                rows[currentRow].append(item)
            } else {
                if rows.count == 1 {
                    rows.append([item])
                    currentRow += 1
                }
            }
        }
        
        return rows
    }
}
