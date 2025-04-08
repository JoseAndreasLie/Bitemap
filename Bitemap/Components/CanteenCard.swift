//
//  ForYouCard.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 24/03/25.
//

import Foundation
import SwiftUI

struct CanteenCard: View {
    @State var canteenName: String
    @State var image: String
    @State var tags: [Tag]
    @State var location: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName:"fork.knife")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.black)
                .padding(.all, 8.0)
                .frame(width: 106, height: 106)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 7){
                HStack{
                    Text(canteenName)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                    Spacer()
                    Image(image)
                        .foregroundColor(.green)
                        .resizable()
                    Text(location)
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .foregroundColor(Color("CustomGreen"))
                    
                }
                Divider()
                ChipLabelView(tags: tags.map { $0.name})
                HStack{
                    Spacer()
                    Button(action: {
                        print("Button tapped")
                    }) {
                        Text("See Menu")
                            .frame(width: 86, height: 27)
                            .font(.system(size: 11, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .background(Color("CustomOrange"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }.padding(.top, 18)
            }
            .padding(.trailing, 4)
            .frame(height: 160)
        }
        .frame(width: UIScreen.main.bounds.width * 0.875)
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
