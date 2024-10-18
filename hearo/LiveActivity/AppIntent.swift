//
//  AppIntent.swift
//  LiveActivity
//
//  Created by 김준수(엘빈) on 10/18/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

// 샘플 데이터 확장 추가
extension LiveActivityAttributes {
    static var preview: LiveActivityAttributes {
        LiveActivityAttributes(name: "주행")
    }
}

extension LiveActivityAttributes.ContentState {
    static var sample: LiveActivityAttributes.ContentState {
        LiveActivityAttributes.ContentState(isWarning: false)
    }

    static var warningSample: LiveActivityAttributes.ContentState {
        LiveActivityAttributes.ContentState(isWarning: true)
    }
}
