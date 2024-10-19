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
        var isWarning: Bool // 경고 상태를 나타냄
    }
    var name: String
}

struct LiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
          
            HStack {
                // UI
                VStack {
                    Text("안전주행중")
                        .font(.headline)
                        .foregroundColor(.white)
                    Button(action: {
                        stopWorking()
                    }) {
                        Label("정지", systemImage: "stop.fill")
                            .foregroundColor(.red)
                    }
                }
                
                Spacer()
                
               
                Image(systemName: "car.fill") // 캐릭터로 대체 예정
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
            .padding()
            .containerBackground(for: .widget) {
                // 배경 설정: 검정색으로 설정
                Color.black
            }
            .activityBackgroundTint(Color.black)
                        .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: context.state.isWarning ? "exclamationmark.triangle" : "figure.walk")
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.isWarning ? "경고 상태" : "주행중")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Button(action: {
                        stopWorking()
                    }) {
                        Image(systemName: "stop.fill")
                    }
                }
            } compactLeading: {
                Image(systemName: context.state.isWarning ? "exclamationmark.triangle" : "figure.walk")
            } compactTrailing: {
                Text("주행중")
            } minimal: {
                Image(systemName: context.state.isWarning ? "exclamationmark.triangle" : "figure.walk")
            }
        }
    }
}

// 정지 함수 예시
func stopWorking() {
    // WorkingViewModel의 주행 종료 기능과 연동해야 합니다.
    NotificationCenter.default.post(name: NSNotification.Name("StopWorkingNotification"), object: nil)
}
