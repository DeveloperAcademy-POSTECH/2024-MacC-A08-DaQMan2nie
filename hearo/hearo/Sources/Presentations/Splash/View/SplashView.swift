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
          
          Image("Hearoad_Main")
            .resizable()
            .frame(width: 139.55, height: 25.68,alignment: .center)
          
          Spacer()
          
<<<<<<< HEAD
          Image("Copyright")
            .resizable()
            .frame(width: 246.24, height: 10.53, alignment: .center)
            .padding(.bottom, 46.69)
=======
          HStack(spacing: 0) {
            
            Text("Copyright 2024.")
              .font(Font.custom("Spoqa Han Sans Neo", size: 12))
              .multilineTextAlignment(.center)
              .foregroundColor(Color("HWhite"))
            Text(" DaQman2ni")
              .font(Font.custom("Spoqa Han Sans Neo-Bold", size: 12))
              .multilineTextAlignment(.center)
              .foregroundColor(Color("HWhite"))
            Text(" in all rights reserved.")
              .font(Font.custom("Spoqa Han Sans Neo", size: 12))
              .multilineTextAlignment(.center)
              .foregroundColor(Color("HWhite"))
            
          }
          .padding(.bottom, 44)
>>>>>>> f8ee93d (fix UI)
          
        }
        
      }
      .onAppear {
<<<<<<< HEAD
        // 1.5초 후 isActive 상태를 true로 변경
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//          self.isActive = true
=======
        // 2초 후 isActive 상태를 true로 변경
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.isActive = true
>>>>>>> f8ee93d (fix UI)
        }
      }
    }
    
  }
}

#Preview {
  SplashView(appRootManager: AppRootManager())
}
