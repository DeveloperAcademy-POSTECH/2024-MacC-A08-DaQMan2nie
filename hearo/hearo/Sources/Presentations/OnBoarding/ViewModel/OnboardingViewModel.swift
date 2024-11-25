//
//  OnboardingViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var currentTab: Int = 0

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
    }

    func moveToNextTab() {
      currentTab += 1
    }

    func moveToHome() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        appRootManager.currentRoot = .home
    }
}
