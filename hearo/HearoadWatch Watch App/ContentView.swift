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
            
            
            // 알림 상태에 따른 아이콘 표시
            if sessionManager.isAlerting {
                            Image(sessionManager.alertImageName())
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .padding()
            }
            else{
                Image("MainCircle")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
            }
        }
        .onAppear {
            // 초기화
            sessionManager.resetAlert()
        }
    }
}
