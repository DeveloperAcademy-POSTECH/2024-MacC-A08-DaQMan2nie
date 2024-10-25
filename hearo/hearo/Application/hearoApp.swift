//
//  hearoApp.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI
import ActivityKit

@main
struct hearoApp: App {
    @StateObject var appRootManager = AppRootManager() // 앱 전역에서 사용되는 상태 관리

    var body: some Scene {
        WindowGroup {
            // ContentView가 루트로 설정됨
            ContentView(appRootManager: appRootManager)
        }
    }
}

// 라이브 액티비티 속성 정의
struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var isWarning: Bool // 경고 상태를 나타냄
    }
    
    var name: String
}

final class AppRootManager: ObservableObject {
    @Published var currentRoot: AppRoot = .splash // 기본값: splash
    @Published var detectedSound: String? = nil // 감지된 소리 저장

    init() {
        // UserDefaults에서 온보딩 완료 여부를 확인하고 기본 루트를 결정
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        self.currentRoot = hasSeenOnboarding ? .home : .splash
      }
  
    // 루트 뷰 상태를 나타내는 열거형
    enum AppRoot {
        case splash
        case onboarding
        case home
        case working
        case finish
        case warning
    }
    
    // 라이브 액티비티 시작 메서드
    func startLiveActivity(isWarning: Bool) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("라이브 액티비티가 지원되지 않거나 비활성화되었습니다.")
            return
        }

        let attributes = LiveActivityAttributes(name: "주행")
        let initialContentState = LiveActivityAttributes.ContentState(isWarning: isWarning)

        do {
            let activity = try Activity<LiveActivityAttributes>.request(
                attributes: attributes,
                contentState: initialContentState,
                pushType: nil
            )
            print("라이브 액티비티가 시작되었습니다: \(activity.id)")
        } catch {
            print("라이브 액티비티 시작 실패: \(error)")
        }
    }
    
    // 라이브 액티비티 중지 메서드
    func stopLiveActivity() {
        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                await activity.end(dismissalPolicy: .immediate)
                print("라이브 액티비티가 중지되었습니다: \(activity.id)")
            }
        }
    }
    
    // 라이브 액티비티 업데이트 메서드
    func updateLiveActivity(isWarning: Bool) {
        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                let updatedContentState = LiveActivityAttributes.ContentState(isWarning: isWarning)
                await activity.update(using: updatedContentState)
                print("라이브 액티비티 상태 업데이트: \(isWarning ? "경고" : "주행 중")")
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var appRootManager: AppRootManager
    
    var body: some View {
        VStack {
            switch appRootManager.currentRoot {
            case .splash:
                SplashView(appRootManager: appRootManager)
            case .onboarding:
                OnboardingView(viewModel: OnboardingViewModel(appRootManager: appRootManager))
            case .home:
                HomeView(viewModel: HomeViewModel(appRootManager: appRootManager))
            case .working:
                WorkingView(viewModel: WorkingViewModel(appRootManager: appRootManager))
            case .finish:
                FinishView(viewModel: FinishViewModel(appRootManager: appRootManager))
            case .warning:
                WarningView(appRootManager: appRootManager)
            }
        }
    }
}
