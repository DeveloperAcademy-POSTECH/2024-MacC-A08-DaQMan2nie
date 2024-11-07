//
//  OnboardingStandRecommendView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingStandRecommendView: View {
  @StateObject var viewModel: OnboardingViewModel
  @Binding var currentPage: Int
  var body: some View {
    ZStack {
      VStack {
        Spacer().frame(height: 45)
        HStack(spacing: 0){
          
          Spacer().frame(width: 16)
          
          VStack(alignment: .leading, spacing: 0){
            Text("정확한 감지를 위해\n주행 중 거치대를 사용해 주세요. ")
              .font(.mainTitle)
              .foregroundStyle(Color("MainFontColor"))
            
            Spacer().frame(height: 12)
            
            Text("안전한 주행을 위한 작은 준비가 큰 차이를 만듭니다.")
              .font(.regular)
              .foregroundStyle(Color("SubFontColor"))

            
          }
          
          Spacer()
          
        }
        Spacer()
      }
      
      Image(systemName: "iphone.gen1.radiowaves.left.and.right")
        .resizable()
        .frame(width: 135.84, height: 180)
        .foregroundColor(Color("HPrimaryColor"))
      
      Spacer().frame(height: 162)
      
//      Button(action: {
//        viewModel.moveToHome() // 홈 화면으로 전환
//      }) {
//        ZStack {
//          Rectangle()
//          //                            .foregroundColor(.clear)
//            .frame(width: 361, height: 58)
//            .background(Color.white)
//            .cornerRadius(10)
//            .opacity(0.28)
//          
//          Text("확인")
//            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
//            .multilineTextAlignment(.center)
//            .foregroundColor(.white)
//        }
//      }
    }
  }
}

#Preview {
  OnboardingStandRecommendView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()), currentPage: .constant(3))
}
