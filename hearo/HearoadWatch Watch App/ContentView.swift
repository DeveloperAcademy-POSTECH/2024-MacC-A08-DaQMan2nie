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
    @State private var timer: Timer? = nil // 타이머 관리
    @State private var showHearoadDefault = true // Hearoad 기본 화면 표시 여부

    var body: some View {
        ZStack {
            // 배경색 설정: 알림 상태, 기본 상태, etc 상태에 따라 변경
            backgroundColor()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if showHearoadDefault {
                    // Hearoad 기본 화면
                    Image("HearoadLetters") // Hearoad 이미지 이름 (녹색 화면)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if sessionManager.isAlerting {
                    // 특정 소리 감지 화면
                    Image(sessionManager.alertImageName()) // Siren, Car, Bicycle 이미지 표시
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Text(sessionManager.alertMessage) // 텍스트: 감지된 소리 이름
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                } else {
                    // ETC 정보 상태 (소리 수집중)
                    Image("MainCircle") // MainCircle 이미지
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    Text("소리 수집중") // 텍스트
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
            }
        }
        .onAppear {
            startResetTimer() // 초기화 타이머 시작
            sessionManager.resetAlert() // 초기 상태 설정
        }
        .onChange(of: sessionManager.isAlerting) { newValue in
            if newValue {
                // Alert 상태가 들어오면 Hearoad 기본 화면 끔
                showHearoadDefault = false
                cancelResetTimer() // 기존 타이머 취소
                startAlertResetTimer() // 알림 상태에서 3초 뒤 복구
            }
        }
        .onChange(of: sessionManager.alertMessage) { newMessage in
            if newMessage == "etc" {
                // etc 정보가 들어오면 기본 상태 유지
                showHearoadDefault = false
                cancelResetTimer()
                startResetTimer() // etc 상태를 유지하는 5초 타이머
            }
        }
    }
    
    // 배경색 결정
    private func backgroundColor() -> Color {
        if showHearoadDefault {
            return   Color("HPrimaryColor") // 기본 Hearoad 화면
        } else if sessionManager.isAlerting {
            return Color.red // Alert 상태
        } else {
            return Color.white // ETC 정보 상태
        }
    }
    
    // 알림 상태에서 3초 뒤 ETC 상태로 복구
    private func startAlertResetTimer() {
        timer?.invalidate() // 기존 타이머 취소
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            sessionManager.resetAlert() // 알림 상태 복구
        }
    }
    
    // ETC 상태에서 5초 뒤 기본 Hearoad 화면으로 전환
    private func startResetTimer() {
        timer?.invalidate() // 기존 타이머 취소
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            showHearoadDefault = true // Hearoad 기본 화면 표시
        }
    }

    private func cancelResetTimer() {
        timer?.invalidate()
        timer = nil
    }
}
