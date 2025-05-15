//
//  FavoriteView.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 14/05/25.
//

import Foundation
import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = ExploreViewModel()
    @State private var likedCanteens: Set<String> = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("FAFAFA").opacity(1)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()
                
                if likedCanteensArray.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(likedCanteensArray, id: \.id) { canteen in
                                NavigationLink(destination: CanteenDetailView(canteen: canteen)) {
                                    LongCard(
                                        title: canteen.nama,
                                        location: canteen.location.name,
                                        image: canteen.location.images.last ?? "map",
                                        tags: canteen.tags.map { $0.name },
                                        isLiked: binding(for: canteen.nama)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadCanteens()
                loadLikedCanteens()
            }
        }
    }
    
    private var likedCanteensArray: [Canteen] {
        viewModel.canteens.filter { canteen in
            likedCanteens.contains(canteen.nama)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.6))
            
            Text("No favorites yet")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Tap the heart icon on any canteen to add it to your favorites")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding()
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
}
#Preview {
    FavoriteView()
}
