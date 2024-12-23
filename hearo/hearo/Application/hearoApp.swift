
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
            .onChange(of: scenePhase) { oldPhase, newPhase in
                handleScenePhaseChange(newPhase)
            }
        }
    }
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {

            switch newPhase {
            case .background:
                // 백그라운드로 전환되면 모든 오디오 및 ML 작업 중지
                appRootManager.stopAudioAndMLTasks()
                // WorkingView일 경우 라이브 액티비티 시작
                if appRootManager.currentRoot == .working {
                    appRootManager.startLiveActivity()
                }
            case .active:
                // 앱이 포그라운드로 돌아올 때 오직 WorkingView 상태에서만 오디오 수집 재개
                appRootManager.resumeAudioTasksIfWorking()
            default:
                break
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

final class AppRootManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = AppRootManager() // 싱글톤 객체

    @Published var currentRoot: AppRoot = .splash {
        didSet {
            // working 상태로 전환될 때 오디오 수집 자동 시작
            if currentRoot == .working {
                hornSoundDetector?.startRecording()
                print("오디오 수집 시작됨")
            } else {
                hornSoundDetector?.stopRecording()
                print("오디오 수집 중지됨")
            }
          
            // 워치 앱으로 현재 상태 전송
            sendCurrentRootToWatch()
        }
    }  // 기본값: splash
    @Published var detectedSound: String? = nil // 감지된 소리 저장
    private var isActivityActive = false // 라이브 액티비티 활성 상태 추적 변수
    private var isWarning = false // isWarning 상태 저장
    private var currentWarningState: Bool = false // 현재 isWarning 상태 저장
    private var hornSoundDetector: HornSoundDetector? // HornSoundDetector 인스턴스
    private let wcSession = WCSession.default
    
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
    
  override init() {
    super.init()
    
    if WCSession.isSupported() {
      wcSession.delegate = self
      wcSession.activate()
    }
  }
  
  private func sendCurrentRootToWatch() {
    let screen: String
    switch currentRoot {
    case .working: screen = "working"
    case .home: screen = "home"
      default : screen = "home" // 기본값으로 HomeView 표시
    }
    
    if wcSession.isReachable {
      wcSession.sendMessage(["currentRoot": screen], replyHandler: nil, errorHandler: { error in
        print("워치로 상태 전송 실패: \(error.localizedDescription)")
      })
    } else {
      do {
        try wcSession.updateApplicationContext(["currentRoot": screen])
      } catch {
        print("워치로 상태 전송 실패: \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: - WCSessionDelegate

      func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

      func sessionDidBecomeInactive(_ session: WCSession) {}

      func sessionDidDeactivate(_ session: WCSession) {}

      func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {}
  
 
    // 스플래시 끝났을 때 호출
    func determineNextRoot() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        self.currentRoot = hasSeenOnboarding ? .home : .startOnboarding
//        self.currentRoot = .startOnboarding
    }
    
    // 라이브 액티비티 시작 메서드
    func startLiveActivity() {
        #if os(iOS) // iOS에서만 라이브 액티비티 실행
        // 기존의 Live Activity가 활성화되어 있는지 확인
        isActivityActive = !Activity<LiveActivityAttributes>.activities.isEmpty
        
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
        let initialContentState = LiveActivityAttributes.ContentState(isWarning: false)
        
        let content = ActivityContent(state: initialContentState, staleDate: Date().addingTimeInterval(6))
        
        do {
            let activity = try Activity<LiveActivityAttributes>.request(
                attributes: attributes,
                content: content
            )
            
            isActivityActive = true
            print("라이브 액티비티가 시작되었습니다: \(activity.id)")
        } catch {
            print("라이브 액티비티 시작 실패: \(error)")
        }
        #else
        print("Apple Watch에서는 라이브 액티비티가 활성화되지 않습니다.")
        #endif
    }

    // 라이브 액티비티 종료 메서드
    func stopLiveActivity() {
        guard !Activity<LiveActivityAttributes>.activities.isEmpty else {
            print("라이브 액티비티가 이미 중지 상태입니다.")
            return
        }
        
        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
                print("라이브 액티비티가 중지되었습니다: \(activity.id)")
            }
            isActivityActive = false
            print("모든 라이브 액티비티가 성공적으로 중지되었습니다.")
        }
    }

    
    // 오디오 및 ML 작업 중지 메서드
        func stopAudioAndMLTasks() {
            hornSoundDetector?.stopRecording()
            print("오디오 수집 및 ML 예측 중지됨")
        }
        
        // Working 상태에서만 오디오 작업 재개
        func resumeAudioTasksIfWorking() {
            if currentRoot == .working {
                hornSoundDetector?.startRecording()
                print("오디오 수집 및 ML 예측 재개됨 (working 상태에서만)")
            } else {
                print("오디오 수집은 working 상태에서만 재개됩니다.")
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

