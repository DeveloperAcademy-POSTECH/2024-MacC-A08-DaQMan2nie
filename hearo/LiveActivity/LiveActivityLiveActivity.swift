//
//  LiveActivityLiveActivity.swift
//  LiveActivity
//
//  Created by 김준수(엘빈) on 10/18/24.
//



import ActivityKit
import WidgetKit
import SwiftUI

// 라이브 액티비티 속성 정의
struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // 현재 상태를 나타내는 속성을 정의 (예: 경고 여부)
        // 하지만 필요 없다면 이 속성을 추가적으로 활용할 수 있습니다.
    }

    var name: String // 이름 속성만 유지
}
struct LiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // UI 구성
            HStack {
                VStack {
                    Text("소리 수집이 중지되었습니다.") // 변경된 메시지
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image(systemName: "exclamationmark.triangle") // 경고 아이콘
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
            .padding()
            .containerBackground(for: .widget) {
                Color.black // 배경 색상
            }
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "exclamationmark.triangle")
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("소리 수집이 중지되었습니다.") // 동일한 메시지
                }
                DynamicIslandExpandedRegion(.trailing) {
                    // 추가 아이콘이나 요소가 필요하다면 여기에 추가
                }
            } compactLeading: {
                Image(systemName: "exclamationmark.triangle")
            } compactTrailing: {
                Text("수집 중지")
            } minimal: {
                Image(systemName: "exclamationmark.triangle")
            }
        }
    }
}
