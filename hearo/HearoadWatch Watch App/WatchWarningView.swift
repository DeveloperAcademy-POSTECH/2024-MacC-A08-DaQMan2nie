////
////  WatchWarningView.swift
////  HearoadWatch Watch App
////
////  Created by Pil_Gaaang on 10/31/24.
////
//
//import Foundation
//import SwiftUI
//import WatchKit
//
//
//struct WatchWarningView: View {
//    @ObservedObject private var sessionManager = WatchSessionManager.shared
//
//    var body: some View {
//        VStack {
//            Text("워닝뷰")
//                .font(.headline)
//                .foregroundColor(.red)
//                .padding()
//            Text("소리 감지: \(sessionManager.alertMessage)")
//                .font(.headline)
//                .foregroundColor(.red)
//                .padding()
//
//            Button("진동 테스트") {
//                WKInterfaceDevice.current().play(.notification) // 수동으로 진동 테스트
//            }
//        }
//    }
//}
