//
//  ChipLabel.swift
//  Bitemap
//
//  Created by Lin Dan Christiano on 27/03/25.
//

import SwiftUI

struct ChipLabelView: View {
    let tags: [String]

    @State private var totalWidth = CGFloat.zero

    var body: some View {
        var width = CGFloat.zero
        var rows: [[String]] = [[]]

        // Membagi tag dalam beberapa baris
        for tag in tags {
            let tagWidth = tag.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 20 // Estimasi padding
            
            if width + tagWidth > totalWidth {
                rows.append([tag]) // Baris baru
                width = tagWidth
            } else {
                rows[rows.count - 1].append(tag)
                width += tagWidth
            }
        }

        return GeometryReader { geo in
            VStack(alignment: .leading, spacing: 8) {
//                ScrollView{
                    ForEach(rows, id: \.self) { row in
                        HStack(spacing: 8) {
                            ForEach(row, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal,8)
                                    .padding(.vertical, 5)
                                    .background(Capsule().stroke(Color.green, lineWidth: 1))
                                    .foregroundColor(.green)
                            }
                        }
//                    }
                }
            }
            .onAppear {
                self.totalWidth = geo.size.width
            }
        }
        .frame(height:70) // Sesuaikan tinggi jika diperlukan
    }
}

//struct ChipLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        ForYouCardView(
//            name: "Kasturi",
//            location: "GOP 9",
//            tags: ["Rice", "Indonesia", "Beef", "Chicken"]
//        )
//        .previewLayout(.sizeThatFits)
//        .padding()
//    }
//}
