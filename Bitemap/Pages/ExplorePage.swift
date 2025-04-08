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
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    showFilterSheet.toggle()
                }) {
                    HStack{
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
                .padding()

                ScrollView {
                    VStack {
                        ForEach(viewModel.filteredKantins, id: \.self) { kantin in
                            NavigationLink(destination: CanteenPage(kantin: kantin)) {
                                CanteenCard(
                                    canteenName: kantin.nama,
                                    image: kantin.location.images[0],
                                    tags: kantin.tags,
                                    location: kantin.location.name
                                )
                                .padding(.vertical, 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Explore")
            .sheet(isPresented: $showFilterSheet) {
                FilterSheet(viewModel: viewModel)
            }
        }
    }
}

struct FilterSheet: View {
    @ObservedObject var viewModel = KantinViewModel()
    @State private var totalWidth: CGFloat = 0
    @State private var currentRow: [Tag] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center){
                    Spacer()
                    Text("Filters")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 8)
                    Spacer()
                }
                ScrollView {
                    GeometryReader { geometry in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Meal Time")
                                .font(.headline)
                            tagChips(tags: ["Breakfast", "Lunch", "Dinner"], geometry: geometry)
                            
                            Text("Cuisine")
                                .font(.headline)
                                .padding(.top, 16)
                            tagChips(tags: ["Indonesia", "Chinese", "Western", "Japanese"], geometry: geometry)
                            
                            Text("Carbs")
                                .font(.headline)
                                .padding(.top, 16)
                            tagChips(tags: ["Rice", "Noodle", "Potato", "Bread"], geometry: geometry)
                            
                            Text("Proteins")
                                .font(.headline)
                                .padding(.top, 16)
                            tagChips(tags: ["Egg", "Chicken", "Duck", "Beef", "Seafood", "Pork", "Lamb"], geometry: geometry)
                            
                            Text("Others")
                                .font(.headline)
                                .padding(.top, 16)
                            tagChips(tags: ["Veggies", "Fruits"], geometry: geometry)
                        }
                        .padding()
                    }
                }
                
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
            .padding()
        }
    }
    
    // Fungsi untuk menampilkan chip button per kategori
    @ViewBuilder
    private func tagChips(tags: [String], geometry: GeometryProxy) -> some View {
        // Menghitung baris chip terlebih dahulu
        let rows = generateRows(for: tags, geometry: geometry)
        
        VStack(alignment: .leading, spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { chip in
                        let tag = Tag(id: chip, name: chip)  // ID dan name disamakan
                        ChipButton(tagName: chip, isSelected: viewModel.selectedTags.contains(tag)) {
                            viewModel.toggleTagSelection(tag: tag)
                        }
                    }
                }
            }
        }
    }
    
    // Fungsi untuk mengelompokkan tag menjadi baris-baris
    private func generateRows(for tags: [String], geometry: GeometryProxy) -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var totalWidth: CGFloat = 0
        
        for tag in tags {
            let tagWidth = tag.size(withAttributes: [.font: UIFont.systemFont(ofSize: 16)]).width + 36
            
            // Jika tidak cukup tempat di baris ini, buat baris baru
            if totalWidth + tagWidth > geometry.size.width {
                rows.append(currentRow)
                currentRow = [tag]
                totalWidth = tagWidth
            } else {
                currentRow.append(tag)
                totalWidth += tagWidth + 8
            }
        }
        
        // Menambahkan sisa chip pada baris terakhir
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    struct ChipButton: View {
        var tagName: String
        var isSelected: Bool
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(tagName)
                    .foregroundColor(.black)
                    .font(.system(size: 17))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isSelected ? Color.blue : Color.white)
                    .cornerRadius(16)
                    .overlay(
                                Capsule()
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
            }
        }
    }
}


#Preview {
    ExplorePage()
}
