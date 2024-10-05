//
//  SplashView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//
import SwiftUI

struct SplashView: View {
    @ObservedObject var appRootManager: AppRootManager
    @State private var isActive = false // 스플래시 화면이 끝났는지 여부를 관리하는 상태

    var body: some View {
        VStack {
            if isActive {
                // 상태를 즉시 변경하여 OnboardingView로 전환
                // EmptyView를 사용하지 않고 상태만 변경
                Color.clear
                    .onAppear {
                        appRootManager.currentRoot = .onboarding // 상태 변경
                    }
            } else {
                // 스플래시 화면의 내용 (예: 로고 또는 이미지)
                Text("스플래시")
                    .font(.largeTitle)
                    .bold()
                    .onAppear {
                        // 2초 후 isActive 상태를 true로 변경
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.isActive = true
                        }
                    }
            }
        }
    }
}
