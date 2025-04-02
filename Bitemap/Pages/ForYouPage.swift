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
    var body: some View {
        VStack{
            NavigationStack(){
                ScrollView{
                    LazyVGrid(columns: columns){
                        ForYouCardView(
                            name: "Kasturi",
                            location: "GOP 9",
                            tags: ["Rice", "Indonesia", "Beef", "Chicken", "Veggies", "Western", "Noodles", "Spicy"]
                        )
                        ForYouCardView(
                            name: "Kasturi",
                            location: "GOP 9",
                            tags: ["Rice", "Indonesia", "Beef", "Chicken", "Veggies", "Western", "Noodles", "Spicy"]
                        )
                        ForYouCardView(
                            name: "Kasturi",
                            location: "GOP 9",
                            tags: ["Rice", "Indonesia", "Beef", "Chicken", "Veggies", "Western", "Noodles", "Spicy"]
                        )
                        ForYouCardView(
                            name: "Kasturi",
                            location: "GOP 9",
                            tags: ["Rice", "Indonesia", "Beef", "Chicken", "Veggies", "Western", "Noodles", "Spicy"]
                        )
                        ForYouCardView(
                            name: "Kasturi",
                            location: "GOP 9",
                            tags: ["Rice", "Indonesia", "Beef", "Chicken", "Veggies", "Western", "Noodles", "Spicy"]
                        )
                        ForYouCardView(
                            name: "Kasturi",
                            location: "GOP 9",
                            tags: ["Rice", "Indonesia", "Beef", "Chicken", "Veggies", "Western", "Noodles", "Spicy"]
                        )
                    }
                }
                
            }
            .navigationBarTitle(Text("For You"))
        }
        
    }
}

#Preview {
    ForYouPage()
}
