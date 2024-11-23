//
//  OnboardingTabView.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/23/24.
//

import SwiftUI

struct OnboardingTabView: View {
    var body: some View {
        VStack {
            Text("이곳은온보딩입니다!")
                .font(.largeTitle)
                .padding()

            Spacer()
        }
        .navigationTitle("Info")
    }
}

struct OnboardingTabView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTabView()
    }
}
