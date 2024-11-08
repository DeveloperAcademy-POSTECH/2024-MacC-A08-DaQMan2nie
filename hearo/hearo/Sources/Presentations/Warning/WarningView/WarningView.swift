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
            Image(viewModel.alertImageName())
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.appRootManager.currentRoot = .working // 자동 전환
        }
    }
}
