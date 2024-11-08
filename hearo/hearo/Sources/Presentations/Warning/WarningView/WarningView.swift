//
//  WarningView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/17/24.
//
import SwiftUI

struct WarningView: View {
    @ObservedObject var viewModel: WarningViewModel // StateObject 대신 ObservedObject로 수정

    var body: some View {
        VStack {
            // 감지된 소리에 따라 알맞은 이미지를 표시
            Image(viewModel.alertImageName())
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 400)
                .padding()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // 3초 후 자동으로 WorkingView로 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                viewModel.appRootManager.currentRoot = .working
            }
        }
    }
}
