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
    
    var body: some View {
        ZStack {
            // 배경색을 alert 상태에 따라 변경
            sessionManager.isAlerting ? Color.red.edgesIgnoringSafeArea(.all) : Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // 상태에 따른 텍스트 표시
                Text(sessionManager.isAlerting ? sessionManager.alertMessage : "인식중")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                
                
                // 알림 아이콘을 표시하고, 알림이 아닐 때는 숨김 처리
                if sessionManager.isAlerting {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.yellow)
                        .padding()
                }
            }
        }
        .onAppear {
            // 초기화
            sessionManager.resetAlert()
        }
    }
}
//struct ContentView: View {
//    @ObservedObject var viewManager = WatchViewManager()
//
//    var body: some View {
//        VStack {
//            if viewManager.currentView == "working" {
//                WatchWorkingView()
//            } else if viewManager.currentView == "warning" {
//                WatchWarningView()
//            } else if viewManager.currentView == "finish" {
//                WatchFinishView()
//            } else {
//                WatchHomeView()
//            }
//        }
//        .onAppear {
//            print("현재 Watch 뷰: \(viewManager.currentView)")
//        }
//    }
//}
