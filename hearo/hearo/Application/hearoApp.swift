
//
//  hearoApp.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI
import ActivityKit
import WatchConnectivity

@main
struct hearoApp: App {
    @StateObject var appRootManager = AppRootManager() // 앱 전역에서 사용되는 상태 관리
    @Environment(\.scenePhase) private var scenePhase // 앱 상태 감지

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color("Background")
                    .ignoresSafeArea(.all)
                ContentView(appRootManager: appRootManager)
            }
            .onChange(of: scenePhase) { newPhase in
                handleScenePhaseChange(newPhase)
            }
        }
    }
    
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        if newPhase == .background && appRootManager.currentRoot == .working {
            appRootManager.startLiveActivity(isWarning: false)
        } else if newPhase == .inactive || newPhase == .active {
            appRootManager.stopLiveActivity()
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
    private var isActivityActive = false // 라이브 액티비티 활성 상태 추적 변수
    private var isWarning = false // isWarning 상태 저장
    private var currentWarningState: Bool = false // 현재 isWarning 상태 저장

    // 루트 뷰 상태를 나타내는 열거형
    enum AppRoot {
        case splash
        case startOnboarding
        case onboarding
        case home
        case working
        case finish
        case warning
    }
    
    // 스플래시 끝났을 때 호출
    func determineNextRoot() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        self.currentRoot = hasSeenOnboarding ? .home : .startOnboarding
    }

    // 라이브 액티비티 시작 메서드
    func startLiveActivity(isWarning: Bool) {
        // 항상 현재 `Live Activity` 상태를 확인하고 초기화
        isActivityActive = Activity<LiveActivityAttributes>.activities.isEmpty == false

        guard !isActivityActive else {
            print("라이브 액티비티가 이미 활성화되어 있습니다.")
            return
        }
        
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("라이브 액티비티가 지원되지 않거나 비활성화되었습니다.")
            return
        }

        // attributes와 initialContentState를 선언
        let attributes = LiveActivityAttributes(name: "주행")
        let initialContentState = LiveActivityAttributes.ContentState(isWarning: isWarning)
        
        let content = ActivityContent(state: initialContentState, staleDate: Date().addingTimeInterval(6)) // 전체 6초
        
        do {
            let activity = try Activity<LiveActivityAttributes>.request(
                attributes: attributes,
                content: content
            )
            
            isActivityActive = true
            currentWarningState = isWarning
            print("라이브 액티비티가 시작되었습니다: \(activity.id)")
        } catch {
            print("라이브 액티비티 시작 실패: \(error)")
        }
    }


    // 라이브 액티비티 종료 메서드
    func stopLiveActivity() {
        guard isActivityActive else {
            print("라이브 액티비티가 이미 중지 상태입니다.")
            return
        }

        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
                print("라이브 액티비티가 중지되었습니다: \(activity.id)")
            }
            
            isActivityActive = false
            currentWarningState = false // 중지되었으므로 상태 리셋
        }
    }

    // 라이브 액티비티 업데이트 메서드
    func updateLiveActivity(isWarning: Bool) {
        let initialContentState = LiveActivityAttributes.ContentState(isWarning: isWarning)
        let content = ActivityContent(state: initialContentState, staleDate: Date().addingTimeInterval(6)) // 전체 6초 유지

        guard isActivityActive else {
            print("활성화된 라이브 액티비티가 없어 업데이트할 수 없습니다.")
            return
        }
        
        // 같은 경고 상태로는 업데이트하지 않도록 체크
        guard isWarning != currentWarningState else {
            print("경고 상태가 이미 \(isWarning)로 설정되어 있습니다.")
            return
        }
        guard let activity = Activity<LiveActivityAttributes>.activities.first else {
            isActivityActive = false
            return
        }
        
        Task {
            _ = LiveActivityAttributes.ContentState(isWarning: isWarning)
            await activity.update(content)
            print("라이브 액티비티 상태 업데이트: \(isWarning ? "경고" : "주행 중")")
        }
    }
}

// ContentView 정의 (AppRootManager 클래스 외부에 위치)
struct ContentView: View {
    @ObservedObject var appRootManager: AppRootManager
    
    var body: some View {
        VStack {
            switch appRootManager.currentRoot {
            case .splash:
                SplashView(appRootManager: appRootManager)
            case .startOnboarding:
                StartOnboardingView(appRootManager: appRootManager)
            case .onboarding:
                OnboardingView(viewModel: OnboardingViewModel(appRootManager: appRootManager))
            case .home:
                HomeView(viewModel: HomeViewModel(appRootManager: appRootManager))
            case .working:
                WorkingView(viewModel: WorkingViewModel(appRootManager: appRootManager))
            case .finish:
                FinishView(viewModel: FinishViewModel(appRootManager: appRootManager))
            case .warning:
                WarningView(viewModel: WarningViewModel(appRootManager: appRootManager))
        }
        }
    }
}
