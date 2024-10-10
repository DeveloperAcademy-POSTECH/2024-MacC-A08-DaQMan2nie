//
//  FinishView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct FinishView: View {
    @ObservedObject var appRootManager: AppRootManager

    var body: some View {
        VStack {
            Text("피니시 화면")
                .font(.largeTitle)
                .padding()

            // 홈 화면으로 돌아가는 버튼
            Button("홈 화면으로 돌아가기") {
                print("홈 화면 버튼")
                appRootManager.currentRoot = .home // 홈 화면으로 전환
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
