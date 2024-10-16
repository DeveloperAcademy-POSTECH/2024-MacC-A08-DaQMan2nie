//
//  hearoApp.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

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

final class AppRootManager: ObservableObject {
    @Published var currentRoot: AppRoot = .splash // 기본값: splash

    // 루트 뷰 상태를 나타내는 열거형
    enum AppRoot {
        case splash
        case onboarding
        case home
        case working
        case finish
        case warning
    }
}

struct ContentView: View {
    @ObservedObject var appRootManager: AppRootManager

    var body: some View {
        // 현재 루트 상태에 따라 적절한 뷰를 보여줌
        Group {
            switch appRootManager.currentRoot {
            case .splash:
                SplashView(appRootManager: appRootManager) // Splash 화면
            case .onboarding:
                OnboardingView(appRootManager: appRootManager) // 온보딩 화면
            case .home:
                HomeView(appRootManager: appRootManager) // 홈 화면
            case .working:
                WorkingView(appRootManager: appRootManager) // 워킹 화면
            case .finish:
                FinishView(appRootManager: appRootManager) // 피니시 화면
            case .warning:
                WarningView(appRootManager: appRootManager) // 워닝 뷰
            }
        }
        .onAppear {
            printCurrentRoot()
        }
    }

    private func printCurrentRoot() {
        switch appRootManager.currentRoot {
        case .splash:
            print("현재 화면: SplashView")
        case .onboarding:
            print("현재 화면: OnboardingView")
        case .home:
            print("현재 화면: HomeView")
        case .working:
            print("현재 화면: WorkingView")
        case .finish:
            print("현재 화면: FinishView")
        case .warning:
            print("현재 화면 : warning")
        }
    }
}
