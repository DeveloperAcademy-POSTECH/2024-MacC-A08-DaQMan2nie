//
//  OnboardingViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var currentPage: Int = 0

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
    }

    func moveToNextPage() {
        currentPage += 1
    }

    func moveToHome() {
        appRootManager.currentRoot = .home
    }
}
