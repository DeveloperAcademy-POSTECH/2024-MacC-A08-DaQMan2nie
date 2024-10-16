//
//  WarningView.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/17/24.
//

import SwiftUI

struct WarningView: View {
    @ObservedObject var appRootManager: AppRootManager

    var body: some View {
        VStack {
            Text("경고!")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding()

            Text("높은 신뢰도의 예기치 못한 소리가 감지되었습니다.")
                .font(.title2)
                .padding()

            Button(action: {
                appRootManager.currentRoot = .home // 경고 이후 다시 홈으로 돌아가는 예시
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
            // 3초 후에 자동으로 WorkingView로 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appRootManager.currentRoot = .working
            }
        }
    }
}
