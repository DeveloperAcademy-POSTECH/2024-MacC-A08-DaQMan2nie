//
//  OnboardingNotiPermissionView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingNotiPermissionView: View {
  @StateObject var viewModel: OnboardingViewModel
  
  var body: some View {
    VStack {
      Spacer().frame(height: 59)
      
      HStack {
        Spacer().frame(width: 16)
        
        Text("경적 소리 감지시\n안전을 위한 알림을 허용하세요")
          .font(
            Font.custom("Spoqa Han Sans Neo", size: 25)
              .weight(.bold)
          )
        //          .foregroundColor(Color("HWhite"))
        
        Spacer()
      }
      
      Spacer().frame(height: 19)
        
      HStack {
        Spacer().frame(width: 16)
        
        Text("안전한 주행을 위해, 주행 중 경적, 사이렌 소리 등\n중요한 경고 신호를 놓치지 않도록 알림을 허용해 주세요.")
          .font(Font.custom("Spoqa Han Sans Neo", size: 13))
          .foregroundColor(Color("HGray2"))
          .frame(width: 295, alignment: .topLeading)
        
        Spacer()
      }
      
      Spacer().frame(height: 139)
      
      Image(systemName: "bell.fill")
        .resizable()
        .frame(width: 138.34, height: 161.72)
        .foregroundColor(Color("HPrimaryColor"))
      
      Spacer().frame(height: 121.28)
      
      Button(action: {
        viewModel.moveToNextPage() // 두 번째 페이지로 전환
      }) {
        ZStack {
          Rectangle()
          //                            .foregroundColor(.clear)
            .frame(width: 361, height: 58)
            .background(Color.white)
            .cornerRadius(10)
            .opacity(0.28)
          
          Text("시작하기")
            .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
            .multilineTextAlignment(.center)
        }
      }
    }
  }
}

#Preview {
  OnboardingNotiPermissionView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()))
}
