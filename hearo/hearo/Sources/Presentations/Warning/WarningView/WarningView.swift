//
//  WarningView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/17/24.
//
import SwiftUI

struct WarningView: View {
    @ObservedObject var viewModel: WarningViewModel

  var body: some View {
    ZStack(alignment: .center) {
      LottieView(animationName: "warning_wave", animationScale: 1, loopMode: .loop)
        .frame(alignment: .center)
        .offset(y:60)
        
      VStack(spacing:0) {
        
        // 감지된 소리에 따라 알맞은 텍스트를 표시
        Image("\(viewModel.alertImageName())-text")
          .padding(.top, 157)
          .padding(.bottom, 90)
          .offset(y: -47)
        
        // 감지된 소리에 따라 알맞은 이미지를 표시
        Image(viewModel.alertImageName())

        Spacer()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("WarningColor"))
    .edgesIgnoringSafeArea(.all)
    .onAppear {
      // 3초 후 자동으로 WorkingView로 전환
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        viewModel.appRootManager.currentRoot = .working
      }
    }
  
    }
}

#Preview {
  WarningView(viewModel: WarningViewModel(appRootManager: AppRootManager()))
}
