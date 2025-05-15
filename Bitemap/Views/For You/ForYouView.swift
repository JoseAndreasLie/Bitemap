import SwiftUI

struct ForYouView: View {
    @StateObject private var viewModel = ForYouViewModel()
    @State private var showingPreferences = false
    @State private var showingConfirmation = false
    @State private var likedCanteens: Set<String> = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
//                Color("#FAFAFA")
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("FAFAFA").opacity(1)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()
                
                if viewModel.userPreferences.isEmpty {
                    emptyStateView
                } else if viewModel.topRecommendedCanteens.isEmpty {
                    noRecommendationsView
                } else {
                    recommendationsView
                }
            }
            .navigationTitle("For You")
            .onAppear {
                viewModel.loadUserPreferences()
                loadLikedCanteens()
            }
            .fullScreenCover(isPresented: $showingPreferences) {
                PreferenceView {
                    showingPreferences = false
                    viewModel.loadUserPreferences()
                }
            }
            .alert("Reset Preferences", isPresented: $showingConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    showingPreferences = true
                }
            } message: {
                Text("Are you sure you want to reset your food preferences?")
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
                    // Find a tag to associate with this favorite
                    if let tag = viewModel.userPreferences.first?.tag {
                        viewModel.addToFavorites(canteenName: canteenName, for: tag)
                    }
                } else {
                    likedCanteens.remove(canteenName)
                }
                // Save changes when toggling favorites
                saveLikedCanteens()
            }
        )
    }
    
    private func loadLikedCanteens() {
        // Collect all favorite canteens from all preferences
        let favorites = viewModel.userPreferences.flatMap {
            $0.favoriteCanteenNames ?? []
        }
        likedCanteens = Set(favorites)
    }
    
    private func saveLikedCanteens() {
        // This could be improved to track which tags each liked canteen belongs to
        if let firstTag = viewModel.userPreferences.first?.tag {
            for canteen in likedCanteens {
                viewModel.addToFavorites(canteenName: canteen, for: firstTag)
            }
        }
    }
    
    private var recommendationsView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.topRecommendedCanteens, id: \.id) { canteen in
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
                    .onTapGesture {
                        // Increment tag counts when user taps a canteen
                        for tag in canteen.tags {
                            viewModel.incrementTagCount(for: tag.name)
                        }
                    }
                }
                resetPreferencesButton
                    .padding(.vertical, 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "fork.knife.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.6))
            
            Text("No preferences set")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Set your food preferences to get personalized recommendations")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button("Set Preferences") {
                showingPreferences = true
            }
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color("CustomGreen"))
            .cornerRadius(12)
            .padding(.top, 16)
            
            Spacer()
        }
        .padding()
    }
    
    private var noRecommendationsView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.6))
            
            Text("Exploring your taste")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("We're getting to know your preferences. Try exploring more canteens!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .padding()
    }
    
    private var resetPreferencesButton: some View {
        Button(action: {
            showingConfirmation = true
        }) {
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 14, weight: .semibold))
                Text("Reset Preferences")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("CustomGreen"),
                        Color("CustomGreen").opacity(0.8)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .shadow(color: Color("CustomGreen").opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
}

#Preview {
    ForYouView()
}
