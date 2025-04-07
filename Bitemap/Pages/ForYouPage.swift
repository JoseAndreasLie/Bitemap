//
//  forYou.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct ForYouPage: View {
    let columns = [
          GridItem(.adaptive(minimum: 150))
        ]
    
    @State private var userPreferences: [UserPreferencesModel] = []
    @StateObject private var viewModel = KantinViewModel()

    
    var body: some View {
        VStack{
            NavigationStack(){
                ScrollView{
                    LazyVGrid(columns: columns){
                        ForEach(viewModel.filteredKantins, id: \.id) { kantin in
                            ForYouCardView(
                                name: kantin.nama,
                                location: kantin.location.name,
                                tags: kantin.tags.map { $0.name }
                            )
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("For You"))
        }
        .onAppear {
            loadUserPreferences()
        }
    }
    private func loadUserPreferences() {
        if let data = UserDefaults.standard.data(forKey: "userPreferences"),
           let decoded = try? JSONDecoder().decode([UserPreferencesModel].self, from: data) {
            userPreferences = decoded
            print("Loaded user preferences:", userPreferences)
            
            // Convert to Tag and inject into viewModel
            let selected = Set(decoded.map { Tag(id: $0.tag, name: $0.tag) })
            viewModel.selectedTags = selected
        } else {
            print("No user preferences found")
        }
    }
}

#Preview {
    ForYouPage()
}
