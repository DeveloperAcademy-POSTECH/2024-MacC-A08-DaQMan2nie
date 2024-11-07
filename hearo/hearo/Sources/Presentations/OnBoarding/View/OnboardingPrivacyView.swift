//
//  OnboardingPrivacyView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingPrivacyView: View {
  @StateObject var viewModel: OnboardingViewModel
  @Binding var currentPage: Int
  
  var body: some View {
    ZStack {
      VStack {
        Spacer().frame(height: 45)
        HStack(spacing: 0){
          
          Spacer().frame(width: 16)
          
          VStack(alignment: .leading, spacing: 0){
            Text("저희는 오직 주행을 위한\n오디오를 써요.")
              .font(.mainTitle)
              .foregroundStyle(Color("MainFontColor"))
            
            Spacer().frame(height: 6)
            
            Text(" • 마이크로 인식된 소리는 오직 위험 신호를 감지하기 위한 목적으로만 사용됩니다.\n\n • 인식되는 소리는 실시간 분석 후 저장하지 않습니다.")
              .font(.regular)
              .foregroundStyle(Color("SubFontColor"))

            
          }
          
          Spacer()
          
        }
        Spacer()
      }
      
      Image(systemName: "lock.shield.fill")
        .resizable()
        .frame(width: 138.34, height: 161.72)
        .foregroundColor(Color("HPrimaryColor"))
      
      Spacer().frame(height: 121.28)
      
//      Button(action: {
//        viewModel.moveToNextPage() // 다음 페이지로 전환
//      }) {
//        ZStack {
//          Rectangle()
//            .frame(width: 361, height: 58)
//            .background(Color.white)
//            .cornerRadius(10)
//            .opacity(0.28)
//          
//          Text("다음")
//            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
//            .multilineTextAlignment(.center)
//        }
//      }
    }
  }
}

#Preview {
  OnboardingPrivacyView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()), currentPage: .constant(2))
}
