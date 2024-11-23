//
//  TabView.swift
//  hearo
//
//  Created by Pil_Gaaang on 11/23/24.
//

import SwiftUI

struct TabViewExample: View {
    @State private var isHomeActive: Bool = false // Info와의 바인딩 상태 관리
    
    var body: some View {
        TabView {
            // 첫 번째 탭 - Info 뷰
            Info(isHomeActive: $isHomeActive) // @Binding 전달
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            
            // 두 번째 탭 - 피드백 뷰
            FeedBack()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("피드백")
                }
            
            // 세 번째 탭 - 온보딩 뷰
            OnboardingTabView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("정보")
                }
        }
    }
}

struct TabViewExample_Previews: PreviewProvider {
    static var previews: some View {
        TabViewExample()
    }
}
