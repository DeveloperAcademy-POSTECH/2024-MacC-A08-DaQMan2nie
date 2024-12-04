//
//  ContentView.swift
//  HearoadWatch Watch App
//
//  Created by Pil_Gaaang on 10/28/24.
//

import SwiftUI
import WatchKit

struct ContentView: View {
  @ObservedObject var sessionManager = WatchSessionManager.shared
  @State private var alertTimer: Timer? = nil // 타이머 관리
  @State private var currentView: String = "working" // 현재 표시중인 뷰
  
  var body: some View {
    ZStack {
      if currentView == "alert" {
        // 알림 화면
        ZStack{
          Color("WarningColor")
            .ignoresSafeArea(.all)
          VStack {
            Text(sessionManager.alertTextName())
              .font(.watchAlert)
              .foregroundStyle(Color.white)
              .padding(.bottom, 10)

            Image(sessionManager.alertImageName())
              .resizable()
              .scaledToFit()
              .frame(width: 140, height: 140)
              .padding(.bottom, 20)
            
          }
        }
      } else if sessionManager.currentScreen == "working" {
        WatchWorkingView()
      } else {
        WatchHomeView()
      }
    }
    .onChange(of: sessionManager.isAlerting) { newValue in
      if newValue {
        // 알림 상태로 전환
        currentView = "alert"
        startAlertTimer()
      }
    }
    .onAppear {
      // 기본 화면 설정
      currentView = sessionManager.currentScreen == "working" ? "working" : "home"
    }
  }
  
  private func startAlertTimer() {
    alertTimer?.invalidate() // 기존 타이머 취소
    alertTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
     // 3초 후 원래 화면으로 복구
      currentView = sessionManager.currentScreen == "working" ? "working" : "home"
      sessionManager.resetAlert() // 알림 상태 초기화
    }
  }
}

#Preview {
  ContentView()
}
