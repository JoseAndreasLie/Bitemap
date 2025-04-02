//
//  ForYouCard.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

//import Foundation
//import SwiftUI
//
//struct ForYouCard: View {
//    let name: String
//    let location: String
//    let tags: [String]
//    
//    var body: some View {
//        Grid{
//            GridRow{
//                // ForYouCanteenCard(), and make it dynamic based on DummyData.json
//                    
//                    VStack{
//                        Color.blue
//                        HStack {
//                                       Text(name)
//                                           .font(.headline)
//                                           .foregroundColor(.black)
//
//                                       Spacer()
//
//                                       Image(systemName: "mappin.and.ellipse") // Ikon lokasi
//                                           .foregroundColor(.green)
//                                       
//                                       Text(location)
//                                           .font(.subheadline)
//                                           .foregroundColor(.green)
//                                   }
//                                   .padding(.top, 5)
//                                   .padding(.horizontal)
//                        Divider()
//                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
//                            ForEach(tags, id: \.self) { tag in
//                                Text(tag)
//                                    .font(.caption)
//                                    .padding(.horizontal, 10)
//                                    .padding(.vertical, 5)
//                                    .background(Capsule().stroke(Color.green, lineWidth: 1))
//                                    .foregroundColor(.green)
//                            }
//                        }
//                        .padding(.vertical, 5)
////                        .padding(5)
//                    }
//                    .frame(width: 200, height: 250)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
////                    .padding()
//                            .background(Color.white)
//                            .cornerRadius(15)
//                            .shadow(radius: 3)
//                }
//            }
//        }
//    }
//    
//    //#Preview {
//    //    ForYouCard( name: "Kasturi",
//    //                location: "GOP 9",
//    //                tags: ["Rice", "Indonesia", "Beef", "Chicken", "Veggies"])
//    //}
//    
//    struct KantinCardView_Previews: PreviewProvider {
//        static var previews: some View {
//            ForYouCard(
//                name: "Kasturi",
//                location: "GOP 9",
//                tags: ["Rice", "Indonesia", "Beef", "Chicken", "Veggies"]
//            )
//            .previewLayout(.sizeThatFits)
//            .padding()
//        }
//    }
import SwiftUI

struct ForYouCardView: View {
    let name: String
    let location: String
    let tags: [String]

    var body: some View {
        VStack(alignment: .leading) {
            // Placeholder Image
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 100)
            Group{
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: "mappin.and.ellipse") // Ikon lokasi
                    .foregroundColor(.green)
                
                Text(location)
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
//            .padding(5)
            ChipLabelView(tags: tags)
            }
            .padding(.horizontal, 10)
        }
        .frame(width: 180, height: 180)
        .padding(.bottom, 5)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 3)
    }
}

// PREVIEW
struct ForYouCardView_Previews: PreviewProvider {
    static var previews: some View {
        ForYouCardView(
            name: "Kasturi",
            location: "GOP 9",
            tags: ["Rice", "Indonesia", "Beef", "Chicken"]
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

