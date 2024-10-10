//
//  WorkingView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//
import SwiftUI

struct WorkingView: View {
    @ObservedObject var appRootManager: AppRootManager

    var body: some View {
        VStack {
            Text("워킹 화면")
                .font(.largeTitle)
                .padding()

            // 피니시 화면으로 이동하는 버튼
            Button("피니시 화면으로 이동") {
                print("피니시 화면 버튼")
                appRootManager.currentRoot = .finish // Finish 화면으로 상태 전환
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
