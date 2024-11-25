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
        Spacer().frame(height: 125)
        
        Text("당신을 위한 소리 감지 앱\n히어로드에 오신 걸 환영해요!")
          .font(.semiBold)
          .multilineTextAlignment(.center)
          .foregroundStyle(Color("MainFontColor"))
          .frame(height: 61)
          .padding(.bottom, 10)
        
        
        
        Text("저희 앱은 주행 중 경적과 사이렌 소리를\n감지하여 알림을 주어, 주행자의 안전을 돕습니다.")
          .font(.LiveActivitySub)
          .multilineTextAlignment(.center)
          .foregroundStyle(.black)
          .frame(alignment: .center)
        
        Spacer().frame(height: 23)
        
        Image("OnboardingCircle")
        
        Spacer()
      }
      
      VStack {
        Spacer()
        Button {
          appRootManager.currentRoot = .onboarding
        } label: {
          Text("확인") // 버튼 텍스트
              .font(.headline)
              .foregroundColor(.white)
              .frame(width: 225, height: 58)
              .background(
                  RoundedRectangle(cornerRadius: 92)
                      .fill(Color.green)
              )
        }
        
        Spacer().frame(height: 63)

      }

    }

  }
}


#Preview {
  StartOnboardingView(appRootManager: AppRootManager())
}
