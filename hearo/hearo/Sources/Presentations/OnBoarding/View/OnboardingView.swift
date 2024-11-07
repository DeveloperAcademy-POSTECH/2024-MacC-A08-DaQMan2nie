//
//  OnboardingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel
    @State private var currentPage = 0

    var body: some View {
        
      ZStack {
        TabView(selection: $currentPage) {
              
            OnboardingWarningView(viewModel:viewModel, currentPage: $currentPage)
              .tag(0)
            
            OnboardingNotiPermissionView(viewModel: viewModel, currentPage: $currentPage)
              .tag(1)
              
              
            OnboardingPrivacyView(viewModel:viewModel, currentPage: $currentPage)
              .tag(2)
              
            OnboardingStandRecommendView(viewModel: viewModel, currentPage: $currentPage)
              .tag(3)
            
            OnboardingWatchView(viewModel: viewModel, currentPage: $currentPage)
              .tag(4)
            
          }
          .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
          .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)
        
        if currentPage == 4 {
          VStack {
            Spacer()
            
            Button(action: {
              viewModel.moveToHome()
            }) {
              ZStack {
                Rectangle()
                  .frame(width: 361, height: 58)
                  .foregroundStyle(Color("HPrimaryColor"))
                  .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Image("시작하기")
              }
            }
            
            Spacer().frame(height: 63)
          }
        }
      }
      
    }
}

#Preview {
  OnboardingView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()))
}
