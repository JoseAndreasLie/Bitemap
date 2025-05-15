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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header image
                if let image = canteen.location.images.last {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
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
                    HStack {
                        Text(canteen.nama)
                            .font(.system(size: 24, weight: .bold))
                        Spacer()
                        locationButton
                    }
                    
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                        Text(canteen.location.name)
                            .foregroundColor(.secondary)
                    }
                    
                    // Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(canteen.tags, id: \.id) { tag in
                                Text(tag.name)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Menu sections
                VStack(alignment: .leading, spacing: 20) {
                    Text("Menu")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Category selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(groupedMenuKeys(), id: \.self) { category in
                                categoryButton(category)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Menu items
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(filteredMenuItems(), id: \.id) { menu in
                            menuItem(menu)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
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
    }
    
    private func categoryButton(_ category: String) -> some View {
        Button(action: {
            selectedCategory = (selectedCategory == category) ? nil : category
        }) {
            Text(category)
                .font(.system(size: 14, weight: selectedCategory == category ? .bold : .medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    selectedCategory == category ?
                        Color("CustomGreen").opacity(0.9) :
                        Color(UIColor.secondarySystemBackground)
                )
                .foregroundColor(selectedCategory == category ? .white : .primary)
                .cornerRadius(10)
                .animation(.easeInOut(duration: 0.2), value: selectedCategory)
        }
    }
    
    private func menuItem(_ menu: Menu) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(menu.nama)
                    .font(.system(size: 16, weight: .medium))
                Text(menu.category)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("Rp \(formatPrice(Int(menu.price)))")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color("CustomGreen"))
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    // ADDED FUNCTIONS
    
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
