//
//  DesktopWidgetTestWidgetEntryView.swift
//  DesktopWidgetTest
//
//  Created by 위대연 on 7/31/25.
//

import SwiftUI

struct DesktopWidgetTestWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        GeometryReader { geometry in
            if let image = entry.image {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                Text("Empty")
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5]))
                    )
            }
        } // GeometryReader
    }
}
