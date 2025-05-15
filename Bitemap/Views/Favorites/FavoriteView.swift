//
//  FavoriteView.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 14/05/25.
//

import Foundation
import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
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
                
                if viewModel.favoriteCanteens.isEmpty {
                    emptyStateView
                        .transition(.opacity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(viewModel.favoriteCanteens.enumerated()), id: \.element.id) { index, canteen in
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
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !viewModel.favoriteCanteens.isEmpty {
                        Button(action: {
                            withAnimation {
                                viewModel.sortFavorites()
                            }
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundColor(Color("CustomGreen"))
                        }
                    }
                }
            }
            .onAppear {
                viewModel.loadCanteens()
                
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
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(Color("CustomGreen").opacity(0.7))
                .padding(24)
                .background(
                    Circle()
                        .fill(Color("CustomGreen").opacity(0.1))
                )
                .padding(.bottom, 8)
            
            Text("No favorites yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Tap the heart icon on any canteen to add it to your favorites")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            NavigationLink(destination: ExploreView()) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Explore Canteens")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
                .background(Color("CustomGreen"))
                .cornerRadius(12)
                .shadow(color: Color("CustomGreen").opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding()
    }
    
    // Create a binding for the liked state of each canteen
    private func binding(for canteenName: String) -> Binding<Bool> {
        return Binding(
            get: { viewModel.likedCanteens.contains(canteenName) },
            set: { isLiked in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    viewModel.updateLikedStatus(canteenName: canteenName, isLiked: isLiked)
                }
            }
        )
    }
}

// Custom button style for cards with haptic feedback
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, newValue in
                if newValue {
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
    }
}

#Preview {
    FavoriteView()
}
