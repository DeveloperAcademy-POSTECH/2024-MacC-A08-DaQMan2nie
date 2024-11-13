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
        // 현재 상태를 나타내는 속성을 정의
    }
    
    var name: String // 이름 속성만 유지
}

struct LiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Live Activity 구성
            HStack {
                VStack(alignment: .leading) {
                    Text("히어로드")
                        .font(.LiveActivitySub)
                        .foregroundColor(.white)
                    Text("소리수집이\n중지되었습니다.")
                        .font(.LiveActivityMain)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Image("AppCaution") // "AppCaution" 이미지를 왼쪽에 추가
                    .resizable()
                    .scaledToFit()
                    .frame(width: 91, height: 91)
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
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Image("AppCaution") // 아이콘
                            .resizable()
                            .scaledToFit()
                            .frame(width: 59, height: 59, alignment: .top)
                           
                        
                        Spacer() // 아이콘과 텍스트 사이 간격
                        
                        VStack(alignment: .leading) { // 텍스트 영역
                            Text("히어로드")
                                .font(.LiveActivitySub)
                                .foregroundColor(Color("SubFontColor"))
                            Text("소리수집이 중지되었습니다.")
                                .font(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: 59) // HStack 최대 너비 설정
                }
            } compactLeading: {
                Image("AppCaution")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            } compactTrailing: {
                Text("수집중지")
                    .font(.DaynamicIsland)
                    .foregroundColor(.white)
            } minimal: {
                Image("AppCaution")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
        }
    }
}
