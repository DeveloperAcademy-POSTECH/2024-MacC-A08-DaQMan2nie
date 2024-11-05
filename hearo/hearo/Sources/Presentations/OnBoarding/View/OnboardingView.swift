//
//  OnboardingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        TabView(selection: $viewModel.currentPage) {
            // 첫 번째 온보딩 페이지
          OnboardingNotiPermissionView(viewModel: viewModel)
            .tag(0)
            
            // 두 번째 온보딩 페이지
          OnboardingPrivacyView(viewModel:viewModel)
            .tag(1)
            
          
          OnboardingWarningView(viewModel:viewModel)
              .tag(2)
            
            // 마지막 온보딩 페이지
              OnboardingStandRecommendView(viewModel: viewModel)
            .tag(3)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
  OnboardingView(viewModel: OnboardingViewModel(appRootManager: AppRootManager()))
}
