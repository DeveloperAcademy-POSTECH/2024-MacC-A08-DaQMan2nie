//
//  StartOnboardingView.swift
//  hearo
//
//  Created by 규북 on 11/7/24.
//

import SwiftUI

struct StartOnboardingView: View {
  
  @ObservedObject var appRootManager: AppRootManager
  
  var body: some View {
    
    
    ZStack(alignment: .top) {
      
      Color("Radish")
        .ignoresSafeArea(.all)
      
      VStack(alignment: .center,spacing: 0) {
        Spacer().frame(height: 100)
        
        Text("당신을 위한 소리 감지 앱\n히어로드에 오신 걸 환영해요!")
          .font(.semiBold)
          .multilineTextAlignment(.center)
          .foregroundStyle(Color("MainFontColor"))
          .padding(.bottom, 9)
          
        
        
        
        Text("저희 앱은 주행 중 경적과 사이렌 소리를\n감지하여 알림을 주어, 주행자의 안전을 돕습니다.")
          .font(.LiveActivitySub)
          .multilineTextAlignment(.center)
          .foregroundStyle(.black)
          .frame(alignment: .center)
        
        
        
//        Image("OnboardingCircle")
//              .resizable()
//                .aspectRatio(contentMode: .fit)
//                  .frame(width: 400, height: 400)
          
          LottieView(animationName: "OnboardindCircle", animationScale: 1, loopMode: .loop)
              .frame(width: 300, height: 300)
//              .scaleEffect(0.8)
              .offset(y: 100)
              
          
        Spacer()
      }
      
      VStack {
        Spacer()
        Button {
          appRootManager.currentRoot = .onboarding
        } label: {
          Text("확인") // 버튼 텍스트
        }
        .buttonStyle(CustomButtonStyle())
        
        
        Spacer().frame(height: 63)

      }

    }

  }
}


#Preview {
  StartOnboardingView(appRootManager: AppRootManager())
}
