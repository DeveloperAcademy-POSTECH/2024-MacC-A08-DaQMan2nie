//
//  WarningView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/17/24.
//
import SwiftUI

struct WarningView: View {
    @StateObject var viewModel: WarningViewModel

        init(appRootManager: AppRootManager) {
            _viewModel = StateObject(wrappedValue: WarningViewModel(appRootManager: appRootManager))
        }

    
    var body: some View {
        VStack {
            Text("경고!")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding()

            // 감지된 소리 종류 표시
            Text(viewModel.detectedSoundMessage)
                .font(.title2)
                .padding()

            Button(action: {
                viewModel.returnToHome() // 홈으로 돌아가기 액션
            }) {
                Text("홈으로 돌아가기")
                    .font(.title)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.autoTransitionToWorkingView() // 자동으로 WorkingView로 전환
        }
    }
}
