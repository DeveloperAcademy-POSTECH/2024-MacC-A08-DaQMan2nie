//
//  OnboardingWarningView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingWarningView: View {
  @StateObject var viewModel: OnboardingViewModel
    var body: some View {
      VStack {
        Spacer().frame(height: 59)
        
        HStack {
          Spacer().frame(width: 16)
          
          Text("우리의 경고 알림은 \n \"보조수단\"일 뿐입니다.")
            .font(
              Font.custom("Spoqa Han Sans Neo", size: 25)
                .weight(.bold)
            )
          
          Spacer()
        }
        
        Spacer().frame(height: 19)
        
          Text("· 이 앱은 위험 신호를 보조적으로 알리는 도구입니다.\n\n"+"· 사용자의 안전 주의는 가장 중요한 요소입니다.\n  항상 주변을 확인해주세요.")
          .foregroundStyle(Color("HGray2"))
          .padding(.leading,40)
          .padding(.trailing)

        
        Spacer().frame(height: 139)
        
        Image(systemName: "exclamationmark.triangle.fill")
          .resizable()
          .frame(width: 138.34, height: 161.72)
          .foregroundColor(Color(red: 255/255, green: 216/255, blue: 19/255, opacity: 1))
        
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
    OnboardingWarningView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()))
}
