//
//  HomeView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var appRootManager: AppRootManager

    var body: some View {
        VStack {
            Text("홈 화면")
                .font(.largeTitle)
                .padding()

            // 워킹 화면으로 이동하는 버튼
            Button("워킹 화면으로 이동") {
                print("워킹 화면 버튼")
                appRootManager.currentRoot = .working // 상태를 변경하여 워킹 화면으로 전환
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
