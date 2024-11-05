//
//  OnboardingPrivacyView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingPrivacyView: View {
  @StateObject var viewModel: OnboardingViewModel
  var body: some View {
    VStack {
      Spacer().frame(height: 59)
      
      HStack {
        Spacer().frame(width: 16)
        
        Text("프라이버시 보호관련 안내")
          .font(
            Font.custom("Spoqa Han Sans Neo", size: 25)
              .weight(.bold)
          )
        
        Spacer()
      }
      
      Spacer().frame(height: 19)
      
      Text("· 녹음된 오디오는 오직 경적 소리 인식 목적으로만 사용됩니다.\n\n"+"· 녹음 데이터는 저장되지 않으며, 실시간으로 분석 후 즉시 삭제됩니다.\n\n"+"· 사용자의 다른 행동이나 대화는 절대 녹음되지 않습니다.")
        .foregroundStyle(Color("HGray2"))
        .padding(.leading,44)
      
      
      
      Spacer().frame(height: 139)
      
      Image(systemName: "lock.shield.fill")
        .resizable()
        .frame(width: 138.34, height: 161.72)
        .foregroundColor(Color("HPrimaryColor"))
      
      Spacer().frame(height: 121.28)
      
      Button(action: {
        viewModel.moveToNextPage() // 다음 페이지로 전환
      }) {
        ZStack {
          Rectangle()
            .frame(width: 361, height: 58)
            .background(Color.white)
            .cornerRadius(10)
            .opacity(0.28)
          
          Text("다음")
            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
            .multilineTextAlignment(.center)
        }
      }
    }
  }
}

#Preview {
  OnboardingPrivacyView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()))
}
