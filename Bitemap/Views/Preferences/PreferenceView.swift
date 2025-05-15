//
//  PreferencePage.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 28/03/25.
//

// PreferencePage.swift - Updated version

import SwiftUI

struct PreferenceView: View {
    var onFinish: () -> Void
    @StateObject private var viewModel = PreferenceViewModel()
    //
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor.systemBackground),
                        Color("CustomOrange").opacity(0.2)
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        Text("What do you like?")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .bold()
                            .padding()
                        
                        tagGrid
                        
                        Spacer()
                        
                        Button("Save Preferences") {
                            viewModel.savePreferences {
                                withAnimation {
                                    onFinish()
                                }
                            }
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: 280)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color("CustomOrange"),
                                    Color("CustomOrange").opacity(0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                        .shadow(color: Color("CustomOrange").opacity(0.3), radius: 8, x: 0, y: 4)
                        .padding(.vertical, 16)
                        .disabled(viewModel.selectedTags.isEmpty)
                        .opacity(viewModel.selectedTags.isEmpty ? 0.7 : 1.0)
                    }
                    .padding(4)
                }
                .padding(.all, 4.0)
                .navigationTitle("Preferences")
            }
        }
    }
    
    private var tagGrid: some View {
        let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
        
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(viewModel.tags, id: \.self) { tag in
                PreferenceButton(
                    isSelected: viewModel.selectedTags.contains(tag),
                    title: tag,
                    action: {
                        viewModel.toggleTag(tag)
                    }
                )
            }
        }
    }
}

#Preview {
    PreferenceView(
        onFinish: {
            print("Done bang")
        }
    )
}
