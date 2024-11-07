//
//  OnboardingWatchView.swift
//  hearo
//
//  Created by 규북 on 11/7/24.
//

import SwiftUI

struct OnboardingWatchView: View {
    @StateObject var viewModel: OnboardingViewModel
  @Binding var currentPage: Int
    var body: some View {
      ZStack {
        VStack {
          Spacer().frame(height: 45)
          HStack(spacing: 0){
            
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading, spacing: 0){
              Text("더 안전한 주행을 위해\n워치 앱을 함께 켜 주세요.")
                .font(.mainTitle)
                .foregroundStyle(Color("MainFontColor"))
              
              Spacer().frame(height: 14)
              
              Text("워치가 있다면 워치 앱을 함께 켜 주세요.\n손목에서 바로 알림을 확인할 수 있습니다.")
                .font(.regular)
                .foregroundStyle(Color("SubFontColor"))

              
            }
            
            Spacer()
            
          }
          Spacer()
        }
        
        Image(systemName: "applewatch")
          .resizable()
          .frame(width: 135.84, height: 180)
          .foregroundColor(Color("HPrimaryColor"))
        
        Spacer().frame(height: 162)
        
//        Button(action: {
//          viewModel.moveToHome() // 홈 화면으로 전환
//        }) {
//          ZStack {
//            Rectangle()
//            //                            .foregroundColor(.clear)
//              .frame(width: 361, height: 58)
//              .background(Color.white)
//              .cornerRadius(10)
//              .opacity(0.28)
//            
//            Text("확인")
//              .font(Font.custom("Spoqa Han Sans Neo", size: 18).weight(.medium))
//              .multilineTextAlignment(.center)
//              .foregroundColor(.white)
//          }
//        }
      }
    }
}

#Preview {
    OnboardingWatchView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()), currentPage: .constant(4))
}
