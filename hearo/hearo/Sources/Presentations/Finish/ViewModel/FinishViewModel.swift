//
//  FinishViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import Foundation
import UIKit

class FinishViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        goToHomeWithDelay()
    }

    private func goToHomeWithDelay() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            triggerSuccessHaptic()
            self?.appRootManager.currentRoot = .home
        }
    }
}
