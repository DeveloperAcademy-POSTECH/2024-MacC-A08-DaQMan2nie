//
//  OnboardingWelcomeView.swift
//  hearo
//
//  Created by 규북 on 10/25/24.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 59)

            HStack {
                Spacer().frame(width: 16)
                
                Text("당신을 위한 소리 감지 앱\n히어로드에 오신 걸 환영합니다!")
                    .font(
                        Font.custom("Spoqa Han Sans Neo", size: 25)
                            .weight(.bold)
                    )
                
                Spacer()
            }
            
            Spacer().frame(height: 19)
            
            HStack {
                Spacer().frame(width: 16)
                
                Text("히어로드는 주행 중 위험 신호를 실시간으로 감지해\n시각과 진동으로 알려드립니다.")
                    .font(Font.custom("Spoqa Han Sans Neo", size: 13))
                    .foregroundColor(Color("HGray2"))
                    .frame(width: 295, alignment: .topLeading)
                
                Spacer()
            }
            
            Spacer().frame(height: 102)
            
          VStack(alignment: .leading) {
            Text("서비스 이용 약관에 동의합니다.")
            Text("히어로 이용 약관에 동의하시면 '앱 시작하기'를 눌러주세요.")
          }
            
            Spacer().frame(height: 120)
        }
    }
}


#Preview {
  OnboardingWelcomeView()
}
