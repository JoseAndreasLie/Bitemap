//
//  explore.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @State private var likedCanteens: Set<String> = []
    @State private var animateCards = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("FAFAFA").opacity(1),
                        Color("FAFAFA").opacity(0.8)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter button
                    filterButton
                    
                    // Active filter chips
                    if !viewModel.selectedTags.isEmpty {
                        activeFilterChips
                    }
                    
                    // Canteen list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(viewModel.filteredCanteens.enumerated()), id: \.element.id) { index, canteen in
                                NavigationLink(destination: CanteenDetailView(canteen: canteen)) {
                                    LongCard(
                                        title: canteen.nama,
                                        location: canteen.location.name,
                                        image: canteen.location.images.last ?? "map",
                                        tags: canteen.tags.map { $0.name },
                                        isLiked: binding(for: canteen.nama)
                                    )
                                    .opacity(animateCards ? 1 : 0)
                                    .offset(y: animateCards ? 0 : 20)
                                    .animation(
                                        .spring(response: 0.5, dampingFraction: 0.8)
                                        .delay(Double(index) * 0.1),
                                        value: animateCards
                                    )
                                }
                                .buttonStyle(CardButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                    .refreshable {
                        await viewModel.refreshCanteens()
                    }
                }
            }
            .navigationTitle("Explore")
            .sheet(isPresented: $viewModel.showFilterSheet) {
                FilterSheetView(viewModel: viewModel)
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.selectedTags)
            .onAppear {
                viewModel.loadCanteens()
                loadLikedCanteens()
                
                // Animate cards when view appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        animateCards = true
                    }
                }
            }
            .onDisappear {
                animateCards = false
            }
        }
    }
    
    // Create a binding for the liked state of each canteen
    private func binding(for canteenName: String) -> Binding<Bool> {
        return Binding(
            get: { likedCanteens.contains(canteenName) },
            set: { isLiked in
                if isLiked {
                    likedCanteens.insert(canteenName)
                    viewModel.saveLikedCanteen(canteenName: canteenName, isLiked: true)
                } else {
                    likedCanteens.remove(canteenName)
                    viewModel.saveLikedCanteen(canteenName: canteenName, isLiked: false)
                }
            }
        )
    }
    
    private func loadLikedCanteens() {
        likedCanteens = viewModel.getLikedCanteens()
    }
    
    private var filterButton: some View {
        Button(action: {
            viewModel.showFilterSheet.toggle()
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
            .background(Color("CustomGreen"))
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var activeFilterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
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
                        .stroke(Color.red.opacity(0.5), lineWidth: 1)
                )
        }
    }
    
    func calculateTagRows(tags: [String], geometry: GeometryProxy) -> [[String]] {
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
}

#Preview {
    ExploreView()
}
