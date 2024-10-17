//
//  FinishViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import Foundation

class FinishViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
    }

    func goToHome() {
        appRootManager.currentRoot = .home
    }
}
