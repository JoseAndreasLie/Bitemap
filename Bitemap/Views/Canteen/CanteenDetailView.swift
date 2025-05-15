//
//  Canteen.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import SwiftUI

struct CanteenDetailView: View {
    let canteen: Canteen
    @State private var showMap = false
    @State private var selectedCategory: String? = nil
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var sizeClass
    
    // For adaptive layout
    @State private var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header image
                    if let image = canteen.location.images.last {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: min(200, geometry.size.height * 0.25)) // Adaptive height
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    colors: [.clear, .black.opacity(0.4)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(12)
                    }
                    
                    // Canteen information
                    VStack(alignment: .leading, spacing: 12) {
                        // Responsive title and location button layout
                        if screenWidth > 350 { // Standard layout for larger screens
                            HStack {
                                Text(canteen.nama)
                                    .font(.system(size: min(24, screenWidth * 0.06), weight: .bold))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                Spacer()
                                locationButton
                            }
                        } else { // Stacked layout for smaller screens
                            Text(canteen.nama)
                                .font(.system(size: min(22, screenWidth * 0.06), weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            locationButton
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                            Text(canteen.location.name)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        
                        // Tags with ChipTag component
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(canteen.tags, id: \.id) { tag in
                                    ChipTag(tag: tag.name)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Menu sections
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Menu")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // Category selector with responsive sizing
                        categorySelector
                        
                        // Menu items
                        menuItemsGrid(columns: adaptiveGridColumns())
                    }
                }
                .padding(.vertical)
                .onAppear {
                    self.screenWidth = geometry.size.width
                }
            }
        }
        .navigationTitle(canteen.nama)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    incrementPreferencesForCanteen()
                    showMap.toggle()
                }) {
                    Image(systemName: "map")
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
        .sheet(isPresented: $showMap) {
            CanteenMapView(canteen: canteen)
        }
    }
    
    // MARK: - Adaptive Components
    
    private var locationButton: some View {
        Button(action: {
            incrementPreferencesForCanteen()
            showMap.toggle()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.system(size: 12))
                Text("View Map")
                    .font(.system(size: 12, weight: .medium))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color("CustomGreen"))
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .fixedSize(horizontal: true, vertical: false)
    }
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: adaptiveSpacing()) {
                ForEach(groupedMenuKeys(), id: \.self) { category in
                    categoryButton(category)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func categoryButton(_ category: String) -> some View {
        Button(action: {
            selectedCategory = (selectedCategory == category) ? nil : category
        }) {
            Text(category)
                .font(.system(size: adaptiveFontSize(base: 14), weight: selectedCategory == category ? .bold : .medium))
                .padding(.vertical, adaptiveVerticalPadding())
                .padding(.horizontal, adaptiveHorizontalPadding())
                .background(
                    selectedCategory == category ?
                        Color("CustomGreen").opacity(0.9) :
                        Color(UIColor.secondarySystemBackground)
                )
                .foregroundColor(selectedCategory == category ? .white : .primary)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle()) // Prevents expansion on smaller devices
        .animation(.easeInOut(duration: 0.2), value: selectedCategory)
    }
    
    // Menu items in a grid for better space utilization
    private func menuItemsGrid(columns: [GridItem]) -> some View {
        let items = filteredMenuItems()
        
        if screenWidth > 500 { // Larger devices - use grid
            return AnyView(
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(items, id: \.id) { menu in
                        menuItem(menu)
                    }
                }
                .padding(.horizontal)
            )
        } else { // Smaller devices - use list
            return AnyView(
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(items, id: \.id) { menu in
                        menuItem(menu)
                    }
                }
                .padding(.horizontal)
            )
        }
    }
    
    private func menuItem(_ menu: Menu) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(menu.nama)
                    .font(.system(size: adaptiveFontSize(base: 16), weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(menu.category)
                    .font(.system(size: adaptiveFontSize(base: 12)))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("Rp \(formatPrice(Int(menu.price)))")
                .font(.system(size: adaptiveFontSize(base: 16), weight: .bold))
                .foregroundColor(Color("CustomGreen"))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(adaptivePadding())
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // MARK: - Adaptive Helper Functions
    
    private func adaptiveGridColumns() -> [GridItem] {
        let width = self.screenWidth
        if width > 800 {
            return [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        } else if width > 500 {
            return [GridItem(.flexible()), GridItem(.flexible())]
        } else {
            return [GridItem(.flexible())]
        }
    }
    
    private func adaptiveFontSize(base: CGFloat) -> CGFloat {
        let scale = min(1.0, screenWidth / 390) // Base scale for iPhone 13
        return max(base * scale, base - 2) // Don't go too small
    }
    
    private func adaptivePadding() -> EdgeInsets {
        let basePadding: CGFloat = 16
        let horizontalAdjust = min(1.0, screenWidth / 390)
        
        return EdgeInsets(
            top: basePadding - 4 * (1-horizontalAdjust),
            leading: basePadding * horizontalAdjust,
            bottom: basePadding - 4 * (1-horizontalAdjust),
            trailing: basePadding * horizontalAdjust
        )
    }
    
    private func adaptiveSpacing() -> CGFloat {
        return screenWidth < 350 ? 8 : 12
    }
    
    private func adaptiveVerticalPadding() -> CGFloat {
        return screenWidth < 350 ? 6 : 8
    }
    
    private func adaptiveHorizontalPadding() -> CGFloat {
        return screenWidth < 350 ? 8 : 12
    }
    
    // MARK: - Data Functions
    
    // Returns unique menu categories in alphabetical order
    private func groupedMenuKeys() -> [String] {
        let categories = Set(canteen.menu.map { $0.category })
        return Array(categories).sorted()
    }
    
    // Filters menu items based on selected category
    private func filteredMenuItems() -> [Menu] {
        if let selectedCategory = selectedCategory {
            return canteen.menu.filter { $0.category == selectedCategory }
        } else {
            return canteen.menu
        }
    }
    
    // Format price with thousand separators
    private func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
    
    // Increment user preferences when interacting with the canteen
    private func incrementPreferencesForCanteen() {
        let newTags = canteen.tags.map { $0.name }
        
        if var savedPreferences = loadUserPreferences() {
            for tag in newTags {
                if let index = savedPreferences.firstIndex(where: { $0.tag == tag }) {
                    savedPreferences[index].count += 1
                } else {
                    savedPreferences.append(UserPreferencesModel(tag: tag, count: 1))
                }
            }
            
            if let encoded = try? JSONEncoder().encode(savedPreferences) {
                UserDefaults.standard.set(encoded, forKey: "userPreferences")
            }
        } else {
            let newPreferences = newTags.map { UserPreferencesModel(tag: $0, count: 1) }
            if let encoded = try? JSONEncoder().encode(newPreferences) {
                UserDefaults.standard.set(encoded, forKey: "userPreferences")
            }
        }
    }
    
    // Load user preferences from UserDefaults
    private func loadUserPreferences() -> [UserPreferencesModel]? {
        if let data = UserDefaults.standard.data(forKey: "userPreferences"),
           let preferences = try? JSONDecoder().decode([UserPreferencesModel].self, from: data) {
            return preferences
        }
        return nil
    }
}

#Preview {
    NavigationView {
        CanteenDetailView(canteen: Canteen(
            id: "1",
            nama: "Kantin Sample",
            location: Location(
                id: "loc1",
                name: "Gedung A",
                images: ["map"],
                desc: ["Located near the main entrance"],
                long: 123.456,
                lat: -6.789
            ),
            tags: [
                Tag(id: "t1", name: "Rice"),
                Tag(id: "t2", name: "Chicken"),
                Tag(id: "t3", name: "Halal")
            ],
            menu: [
                Menu(id: "m1", nama: "Nasi Goreng", category: "Makanan", price: 15000),
                Menu(id: "m2", nama: "Es Teh", category: "Minuman", price: 5000),
                Menu(id: "m3", nama: "Soto Ayam", category: "Makanan", price: 20000),
                Menu(id: "m4", nama: "Jus Alpukat", category: "Minuman", price: 12000)
            ]
        ))
    }
}

// Preview for smaller devices
#Preview {
    NavigationView {
        CanteenDetailView(canteen: Canteen(
            id: "1",
            nama: "Kantin Sample dengan Nama yang Panjang",
            location: Location(
                id: "loc1",
                name: "Gedung A dengan lokasi yang panjang sekali",
                images: ["map"],
                desc: ["Located near the main entrance"],
                long: 123.456,
                lat: -6.789
            ),
            tags: [
                Tag(id: "t1", name: "Rice"),
                Tag(id: "t2", name: "Chicken"),
                Tag(id: "t3", name: "Halal"),
                Tag(id: "t4", name: "Vegetarian Options Available")
            ],
            menu: [
                Menu(id: "m1", nama: "Nasi Goreng Special dengan Telur", category: "Makanan", price: 15000),
                Menu(id: "m2", nama: "Es Teh Manis", category: "Minuman", price: 5000),
                Menu(id: "m3", nama: "Soto Ayam Kampung", category: "Makanan", price: 20000),
                Menu(id: "m4", nama: "Jus Alpukat", category: "Minuman", price: 12000)
            ]
        ))
    }
}
