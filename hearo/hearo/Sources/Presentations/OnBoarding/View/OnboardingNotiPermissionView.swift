//
//  OnboardingNotiPermissionView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingNotiPermissionView: View {
  @StateObject var viewModel: OnboardingViewModel
  @Binding var currentPage: Int
  
  var body: some View {
    ZStack {
      VStack {
        Spacer().frame(height: 45)
        HStack(spacing: 0){
          
          Spacer().frame(width: 16)
          
          VStack(alignment: .leading, spacing: 0){
            Text("경적 소리 감지 시\n안전을 위해 알림을 허용해 주세요.")
              .font(.mainTitle)
              .foregroundStyle(Color("MainFontColor"))
            
            Spacer().frame(height: 19)
            
            Text("안전한 주행을 위해, 주행 중 경적 사이렌 소리 등\n중요한 경고 신호를 놓치지 않도록 알림을 허용해 주세요.")
              .font(.regular)
              .foregroundStyle(Color("SubFontColor"))

            
          }
          
          Spacer()
          
        }
        Spacer()
      }
      
      Image(systemName: "bell.fill")
        .resizable()
        .frame(width: 138.34, height: 161.72)
        .foregroundColor(Color("HPrimaryColor"))
      
      Spacer().frame(height: 121.28)
      
//      Button(action: {
//        viewModel.moveToNextPage() // 두 번째 페이지로 전환
//      }) {
//        ZStack {
//          Rectangle()
//          //                            .foregroundColor(.clear)
//            .frame(width: 361, height: 58)
//            .background(Color.white)
//            .cornerRadius(10)
//            .opacity(0.28)
//          
//          Text("시작하기")
//            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
//            .multilineTextAlignment(.center)
//        }
//      }
    }
  }
}

#Preview {
  OnboardingNotiPermissionView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()), currentPage: .constant(1))
}
