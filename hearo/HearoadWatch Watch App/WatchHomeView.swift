//
//  WatchHomeView.swift
//  HearoadWatch Watch App
//
//  Created by 규북 on 12/5/24.
//

import SwiftUI

struct WatchHomeView: View {
    var body: some View {
        ZStack {
            Color("Radish")
                .ignoresSafeArea(.all)
                
                Text("히어로드와 함께\n안전한 주행하세요!\n")
                    .font(Font.custom("Pretendard", size: 20).weight(.medium))
                    .foregroundColor(Color("MainFontColor"))
                    .multilineTextAlignment(.center)
                    .offset(y:-65)
                
                Image("HomeViewCircle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270, height: 270, alignment: .center)
                    .offset(y:115)
       }

    }
}

#Preview {
    WatchHomeView()
}
