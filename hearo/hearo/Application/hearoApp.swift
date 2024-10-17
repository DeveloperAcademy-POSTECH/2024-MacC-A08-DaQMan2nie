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
    @Published var detectedSound: String? = nil // 감지된 소리 저장

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
                WarningView(appRootManager: appRootManager)        }
            
        }
        
    }
}
