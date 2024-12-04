//
//  WatchWorkingView.swift
//  HearoadWatch Watch App
//
//  Created by 규북 on 12/5/24.
//

import SwiftUI

struct WatchWorkingView: View {
    var body: some View {
        ZStack{
            Color("Radish")
                .ignoresSafeArea(.all)
            Text("소리 수집중")
                .font(Font.custom("Pretendard", size: 26).weight(.medium))
                .foregroundColor(Color("SubFontColor"))
                .multilineTextAlignment(.center)
                .offset(y:-90)
            Image("WorkingViewCircle")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160, alignment: .center)
                .offset(y:10)
        }
    }
}

#Preview {
    WatchWorkingView()
}
