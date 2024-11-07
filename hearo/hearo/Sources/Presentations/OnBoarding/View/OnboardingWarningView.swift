//
//  OnboardingWarningView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingWarningView: View {
  @StateObject var viewModel: OnboardingViewModel
  @Binding var currentPage: Int
  
  var body: some View {
    ZStack {
      
      
      VStack {
        Spacer().frame(height: 45)
        
        HStack(spacing: 0){
          Spacer().frame(width: 16)
          
          VStack(alignment: .leading, spacing: 0){
            Text("우리의 경고 알림은 \n \"보조 수단\"이에요.")
              .font(.mainTitle)
              .foregroundStyle(Color("MainFontColor"))
            
            Spacer().frame(height: 19)
            
            Text("저는 당신의 곁에서 위험을 감지해 드리지만, 무엇보다\n중요한 건 자신의 안전이에요. 함께 신중히 주행해요.")
              .font(.regular)
              .foregroundStyle(Color("SubFontColor"))
//              .padding(.trailing, 54)
            
          }
          
          Spacer()
          
        }
        Spacer()
      }
      
      
      
      Image(systemName: "exclamationmark.triangle.fill")
        .resizable()
        .frame(width: 138.34, height: 161.72)
        .foregroundColor(Color(red: 255/255, green: 216/255, blue: 19/255, opacity: 1))
      
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
  OnboardingWarningView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()), currentPage: .constant(0))
}
