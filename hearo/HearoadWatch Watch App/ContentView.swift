//
//  ContentView.swift
//  HearoadWatch Watch App
//
//  Created by Pil_Gaaang on 10/28/24.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    @ObservedObject private var sessionManager = WatchSessionManager.shared

    var body: some View {
        VStack {
            Text("소리 감지: \(sessionManager.alertMessage)")
                .font(.headline)
                .foregroundColor(.red)
                .padding()
            
            Button("진동 테스트") {
                WKInterfaceDevice.current().play(.notification) // 수동으로 진동 테스트
            }
        }
    }
}
