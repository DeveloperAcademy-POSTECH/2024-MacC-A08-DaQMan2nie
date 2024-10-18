//
//  LiveActivityBundle.swift
//  LiveActivity
//
//  Created by 김준수(엘빈) on 10/18/24.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivityBundle: WidgetBundle {
    var body: some Widget {
        // 라이브 액티비티 위젯 추가
        LiveActivity()
        LiveActivityLiveActivity() // 다이내믹 아일랜드와 연결된 라이브 액티비티 추가
    }
}
