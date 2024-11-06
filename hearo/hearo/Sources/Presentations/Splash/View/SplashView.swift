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
          

          Image("Copyright")
            .resizable()
            .frame(width: 246.24, height: 10.53, alignment: .center)
            .padding(.bottom, 46.69)

          
        }
        
      }
      .onAppear {

        // 1.5초 후 isActive 상태를 true로 변경
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
          self.isActive = true
        }
      }
    }
    
  }
}

#Preview {
  SplashView(appRootManager: AppRootManager())
}
