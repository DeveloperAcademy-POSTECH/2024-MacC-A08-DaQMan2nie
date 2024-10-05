//
//  OnboardingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appRootManager: AppRootManager

    var body: some View {
        TabView {
            // 첫 번째 온보딩 페이지
            VStack {
                Text("온보딩 첫 번째 페이지")
                    .font(.title)
                    .padding()
            }

            // 두 번째 온보딩 페이지
            VStack {
                Text("온보딩 두 번째 페이지")
                    .font(.title)
                    .padding()
            }

            // 세 번째 온보딩 페이지
            VStack {
                Text("온보딩 세 번째 페이지")
                    .font(.title)
                    .padding()
            }

            // 네 번째 온보딩 페이지 (마지막 페이지)
            VStack {
                Text("온보딩 네 번째 페이지")
                    .font(.title)
                    .padding()

                // 홈 화면으로 이동하는 버튼
                Button("시작하기") {
                    appRootManager.currentRoot = .home // 홈 화면으로 전환
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .tabViewStyle(PageTabViewStyle()) // TabView 스타일 지정: 페이지 스와이프 가능
    }
}
