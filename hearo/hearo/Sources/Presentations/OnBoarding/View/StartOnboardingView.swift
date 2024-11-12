//
//  StartOnboardingView.swift
//  hearo
//
//  Created by 규북 on 11/7/24.
//

import SwiftUI

struct StartOnboardingView: View {
  
  @ObservedObject var appRootManager: AppRootManager
  @State private var showTitle = false
  @State private var showSubtitle = false
  
  var body: some View {
    
    
    ZStack(alignment: .topLeading) {
      
      Color("Radish")
        .ignoresSafeArea(.all)
      
      VStack(alignment: .leading,spacing: 0) {
        Spacer().frame(height: 45)
        
        Text("당신을 위한 소리 감지 앱\n히어로드에 오신 걸 환영합니다!")
          .font(.mainTitle)
          .foregroundStyle(Color("MainFontColor"))
          .frame(height: 61)
          .opacity(showTitle ? 1 : 0)
          .animation(.easeIn(duration: 1.0), value: showTitle) // 타이핑 애니메이션 효과
          .padding(.bottom, 10)
        
        
        
        Text("히어로드는 주행 중 경적과 사이렌 소리를 감지해\n 주행자의 안전을 돕는 앱입니다.")
          .font(.regular)
          .foregroundStyle(Color("SubFontColor"))
          .frame(maxWidth: 323, minHeight: 42, alignment: .leading)
          .opacity(showSubtitle ? 1 : 0)
          .animation(.easeIn(duration: 1.0).delay(1.0), value: showSubtitle) // 타이핑 애니메이션 효과
      }
      .padding(.leading, 16)
    }
    .overlay{
      Image("MainCircle")
        .offset(y:300)
    }
      
      .onAppear {
        // 애니메이션 트리거
        showTitle = true
        showSubtitle = true
        
        // 3초 후 TabView로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          appRootManager.currentRoot = .onboarding
        }
      }
  }
}


#Preview {
  StartOnboardingView(appRootManager: AppRootManager())
}
