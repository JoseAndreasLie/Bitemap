//
//  explore.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import SwiftUI

struct ExplorePage: View {
    @ObservedObject var viewModel = KantinViewModel()
    @State private var showFilterSheet = false
    @State private var isShowingFilter = false
    
    var body: some View {
        ZStack {
            // Fixed background gradient that doesn't change with filter selection
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(UIColor.systemBackground),
                    Color("CustomOrange").opacity(0.3)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
            
            navigationContent
        }
        .onAppear{
            print()
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheet(viewModel: viewModel)
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.selectedTags)
    }
    
    @ViewBuilder
    private var activeFilterChips: some View {
        if !viewModel.selectedTags.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // Convert Set to Array before using ForEach
                    ForEach(Array(viewModel.selectedTags), id: \.self) { tag in
                        filterChip(for: tag)
                    }
                    
                    if viewModel.selectedTags.count > 1 {
                        clearAllButton
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
    
    private func filterChip(for tag: Tag) -> some View {
        HStack(spacing: 4) {
            Text(tag.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
            
            Button(action: {
                viewModel.toggleTagSelection(tag: tag)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
        )
    }
    
    private var clearAllButton: some View {
        Button(action: {
            viewModel.clearAllTags()
        }) {
            Text("Clear All")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.red.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.red.opacity(0.3), lineWidth: 0.5)
                )
        }
    }
    
    private var navigationContent: some View {
        NavigationStack {
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor.systemBackground),
                        Color("CustomOrange").opacity(0.3)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        // Filter button inside scrollable content
                        filterButton
                        
                        // Active filters inside scrollable content
                        activeFilterChips
                        
                        // Canteen cards
                        VStack {
                            ForEach(viewModel.filteredKantins, id: \.self) { kantin in
                                NavigationLink(destination: CanteenPage(kantin: kantin)) {
                                    CanteenCard(
                                        canteenName: kantin.nama,
                                        image: kantin.location.images.last ?? kantin.location.images[0],
                                        tags: kantin.tags,
                                        location: kantin.location.name
                                    )
                                    .padding(.vertical, 4)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
                .background(Color.clear)
            }
            .navigationTitle("Explore")
        }
    }
    
    // Filter button definition
    private var filterButton: some View {
        Button(action: {
            showFilterSheet.toggle()
        }) {
            HStack {
                Text("Choose Filter")
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.customGreen)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

// Split FilterSheet into a separate file if possible to reduce complexity
struct FilterSheet: View {
    @ObservedObject var viewModel: KantinViewModel
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
            VStack(alignment: .leading, spacing: 6) {
                filterSection(title: "Meal Time", tags: ["Breakfast", "Lunch", "Dinner"], geometry: geometry)
                filterSection(title: "Cuisine", tags: ["Indonesia", "Chinese", "Western", "Japanese"], geometry: geometry)
                    .padding(.top, 16)
                filterSection(title: "Carbs", tags: ["Rice", "Noodle", "Potato", "Bread"], geometry: geometry)
                    .padding(.top, 16)
                filterSection(title: "Proteins", tags: ["Egg", "Chicken", "Duck", "Beef", "Seafood", "Pork", "Lamb"], geometry: geometry)
                    .padding(.top, 16)
                filterSection(title: "Others", tags: ["Veggies", "Fruits"], geometry: geometry)
                    .padding(.top, 16)
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
            viewModel.objectWillChange.send()
            dismiss()
        }) {
            Text("Apply Filter")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.customGreen)
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
            
            if totalWidth + tagWidth > geometry.size.width {
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

#Preview {
    ExplorePage()
}
