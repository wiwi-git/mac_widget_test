//
//  DesktopWidgetTestWidget.swift
//  DesktopWidgetTestWidget
//
//  Created by 위대연 on 7/22/25.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let timeline = Timeline(entries: [SimpleEntry(date: Date())], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
}

struct DesktopWidgetTestWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        GeometryReader { geometry in
            Image("sampleImage") // 프로젝트 Assets에 추가한 이미지 이름
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
    }
}

struct DesktopWidgetTestWidget: Widget {
    let kind: String = "YourWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
          DesktopWidgetTestWidgetEntryView(entry: entry)
            .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("Full-bleed Image Widget")
        .description("A widget that shows an image without borders or padding.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .disableContentMarginsIfNeeded()
    }
}

extension WidgetConfiguration {
    func disableContentMarginsIfNeeded() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}
