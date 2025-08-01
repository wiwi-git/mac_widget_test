//
//  DesktopWidgetTestWidget.swift
//  DesktopWidgetTestWidget
//
//  Created by 위대연 on 7/22/25.
//

import WidgetKit
import SwiftUI
import os.log


struct Provider: TimelineProvider {
    private func loadImage() -> NSImage? {
        os_log("[WidgetLog] 1. loadImage() called.", log: OSLog.default, type: .debug)
        let userDefaults = UserDefaults(suiteName: "group.desktopw.dy")
        guard let imageData = userDefaults?.data(forKey: "widgetImageData") else {
            os_log("[WidgetLog] 2. Failed: No image data found in UserDefaults.", log: OSLog.default, type: .error)
            return nil
        }
        os_log("[WidgetLog] 2. Success: Found image data (%{public}d bytes).", log: OSLog.default, type: .debug, imageData.count)
        
        if let image = NSImage(data: imageData) {
            os_log("[WidgetLog] 3. Success: Image loaded successfully from data!", log: OSLog.default, type: .debug)
            return image
        } else {
            os_log("[WidgetLog] 3. Failed: NSImage(data:) returned nil.", log: OSLog.default, type: .error)
            return nil
        }
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: loadImage())
        completion(entry)
    }


}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: NSImage?
}

struct DesktopWidgetTestWidget: Widget {
    let kind: String = "DesktopWidgetTestWidget"

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
