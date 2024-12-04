//
//  SplashView.swift
//  HearoadWatch Watch App
//
//  Created by 규북 on 12/4/24.
//

import SwiftUI

struct SplashView: View {
  @State private var showSplash: Bool = true
  
    var body: some View {
        if showSplash {
          ZStack(alignment: .center) {
            Color("HPrimaryColor")
              .edgesIgnoringSafeArea(.all)
            
            Image("HearoadLetters") // Hearoad 이미지 이름 (녹색 화면)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
          .onAppear {
            // 2초 후 스플래시 화면 종료
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              self.showSplash = false
            }
          }
        } else {
          ContentView() // 스플래시 화면 종료 후 ContentView로 전환
        }
      
    }
}

#Preview {
    SplashView()
}
