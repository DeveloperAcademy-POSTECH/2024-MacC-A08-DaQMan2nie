//
//  SplashView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//
import SwiftUI

struct SplashView: View {
  var appRootManager: AppRootManager // 인자로 받기
  @State private var isActive = false // 스플래시 화면이 끝났는지 여부를 관리하는 상태
  
  var body: some View {
    ZStack {
      
      Color("HPrimaryColor")
        .ignoresSafeArea(.all)
      
      VStack {
        if isActive {
          Color.clear
            .onAppear {
              appRootManager.determineNextRoot() // splash 후 다음 화면 결정
            }
        } else {
          
          Spacer().frame(height: 217)
          
          Text("Hearoad")
            .font(Font.custom("Inter", size: 34.80519)
              .weight(.medium)
            )
            .multilineTextAlignment(.center)
            .foregroundColor(Color("HWhite"))
          
          Spacer()
          
          Text("Copyright 2024. DaQman2ni in all rights reserved.")
            .font(Font.custom("Spoqa Han Sans Neo", size: 12))
            .multilineTextAlignment(.center)
            .foregroundColor(Color("HWhite"))
          
          Spacer().frame(height: 44)
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
}

#Preview {
  SplashView(appRootManager: AppRootManager())
}
