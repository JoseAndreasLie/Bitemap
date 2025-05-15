//
//  FilterSheetView.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import SwiftUI

struct FilterSheetView: View {
    @ObservedObject var viewModel: ExploreViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                filterHeader

                ScrollView {
                    filterContent
                }

                applyButton
            }
            .padding()
        }
    }

    private var filterHeader: some View {
        HStack(alignment: .center) {
            Spacer()
            Text("Filters")
                .font(.title)
                .bold()
                .padding(.bottom, 8)
            Spacer()
        }
    }

    private var filterContent: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.getTagsByCategory().keys.sorted(), id: \.self) { category in
                    filterSection(title: category,
                                tags: viewModel.getTagsByCategory()[category] ?? [],
                                geometry: geometry)
                }
            }
            .padding()
        }
    }

    private func filterSection(title: String, tags: [String], geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            tagChips(tags: tags, geometry: geometry)
        }
    }

    private var applyButton: some View {
        Button(action: {
            dismiss()
        }) {
            Text("Apply Filter")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("CustomGreen"))
                .cornerRadius(8)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func tagChips(tags: [String], geometry: GeometryProxy) -> some View {
        let rows = generateRows(for: tags, geometry: geometry)

        VStack(alignment: .leading, spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { chip in
                        let tag = Tag(id: chip, name: chip)
                        ChipButton(tagName: chip, isSelected: viewModel.selectedTags.contains(tag)) {
                            viewModel.toggleTagSelection(tag: tag)
                        }
                    }
                }
            }
        }
    }

    private func generateRows(for tags: [String], geometry: GeometryProxy) -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var totalWidth: CGFloat = 0

        for tag in tags {
            let tagWidth = tag.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 36

            if totalWidth + tagWidth > geometry.size.width - 32 {
                rows.append(currentRow)
                currentRow = [tag]
                totalWidth = tagWidth
            } else {
                currentRow.append(tag)
                totalWidth += tagWidth + 8
            }
        }

        if !currentRow.isEmpty {
            rows.append(currentRow)
        }

        return rows
    }
}

struct ChipButton: View {
    var tagName: String
    var isSelected: Bool
    var action: () -> Void
    @State private var isPressing = false
    
    var body: some View {
        Button(action: action) {
            Text(tagName)
                .foregroundColor(isSelected ? .white : .primary)
                .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    Color("CustomGreen") :
                        Color(UIColor.secondarySystemBackground)
                )
                .cornerRadius(16)
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.4), lineWidth: 1)
                )
                .shadow(
                    color: isSelected ? Color("CustomGreen").opacity(0.3) : Color.clear,
                    radius: isPressing ? 2 : 3,
                    x: 0,
                    y: isPressing ? 1 : 1
                )
                .scaleEffect(isPressing ? 0.97 : 1)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
                .animation(.easeInOut(duration: 0.1), value: isPressing)
        }
        .pressEvents(onPress: { isPressing = true }, onRelease: { isPressing = false })
    }
}
