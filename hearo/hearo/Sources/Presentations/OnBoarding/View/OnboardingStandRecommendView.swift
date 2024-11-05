//
//  OnboardingStandRecommendView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingStandRecommendView: View {
  @StateObject var viewModel: OnboardingViewModel
  var body: some View {
    VStack {
      Text("정확한 위치 확인을 위해서\n거치대를 확인해주세요")
        .font(
          Font.custom("Spoqa Han Sans Neo", size: 25)
            .weight(.bold)
        )
        .frame(width: 393, alignment: .leading)
        .padding()
      
      
      
      Text("더 안전하고 정확한 경고 알림을 받기 위해\n스마트폰을 거치대에 고정해 주행해 주세요.")
        .font(Font.custom("Spoqa Han Sans Neo", size: 14))
        .foregroundStyle(Color("HGray2"))
        .frame(width: 345, alignment: .topLeading)
      
      
      Spacer().frame(height: 139)
      
      Image(systemName: "iphone.gen1.radiowaves.left.and.right")
        .resizable()
        .frame(width: 135.84, height: 180)
        .foregroundColor(Color("HPrimaryColor"))
      
      Spacer().frame(height: 162)
      
      Button(action: {
        viewModel.moveToHome() // 홈 화면으로 전환
      }) {
        ZStack {
          Rectangle()
          //                            .foregroundColor(.clear)
            .frame(width: 361, height: 58)
            .background(Color.white)
            .cornerRadius(10)
            .opacity(0.28)
          
          Text("확인")
            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
        }
      }
    }
  }
}

#Preview {
  OnboardingStandRecommendView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()))
}
