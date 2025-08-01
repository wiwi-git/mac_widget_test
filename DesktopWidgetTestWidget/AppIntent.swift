/*
//
//  AppIntent.swift
//  DesktopWidgetTestWidget
//
//  Created by 위대연 on 7/22/25.
//

import WidgetKit
import AppIntents

struct UpdateWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Update Image Widget"
    static var description = IntentDescription("Updates the widget with the selected image.")

    // We don't need any parameters from the user for this intent.
    // The app will provide the necessary data.

    func perform() async throws -> some IntentResult {
        // This tells WidgetKit to reload the timeline for our specific widget.
        WidgetCenter.shared.reloadTimelines(ofKind: "DesktopWidgetTestWidget")
        return .result()
    }
}
*/