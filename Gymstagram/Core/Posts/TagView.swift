//
//  TagView.swift
//  Gymstagram
//
//  Created by Kushal Patel on 7/27/24.
//

import SwiftUI

struct TagView: View {
    var tags: [String]

    var body: some View {
        HStack() {
            ForEach(tags, id: \.self) { tag in
                let color = randomColor()
                Text(tag)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(color, lineWidth: 2))
                    .foregroundColor(color)
                    .padding(.trailing, 4)
            }
        }
    }

    func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}
