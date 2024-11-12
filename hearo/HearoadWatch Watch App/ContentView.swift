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

    // 디바이스 화면 크기에 따라 동적으로 크기 조정
       private var dynamicFrameSize: CGFloat {
           let screenBounds = WKInterfaceDevice.current().screenBounds
           let screenWidth = screenBounds.width
           return screenWidth * 0.9 // 화면 너비의 90%를 기준으로 크기 설정
       }

       var body: some View {
           // 배경색 변경: 알림 상태에 따라 다르게 설정
           sessionManager.isAlerting ? Color.red.edgesIgnoringSafeArea(.all) : Color.black.edgesIgnoringSafeArea(.all)
           ZStack {
               VStack {
                   // 알림 상태에 따라 아이콘 표시
                   if sessionManager.isAlerting {
                       // 알림 메시지에 따른 아이콘 표시
                       Image(sessionManager.alertImageName())
                           .resizable()
                           .scaledToFit()
                           .frame(width: dynamicFrameSize, height: dynamicFrameSize)
                           .padding()
                   } else {
                       // 기본 상태 아이콘 표시
                       Image("Icon")
                           .resizable()
                           .scaledToFit()
                           .frame(width: dynamicFrameSize, height: dynamicFrameSize)
                           .padding()
                   }
               }
           }
           .onAppear {
               // 초기 상태로 초기화
               sessionManager.resetAlert()
           }
       }
   }
