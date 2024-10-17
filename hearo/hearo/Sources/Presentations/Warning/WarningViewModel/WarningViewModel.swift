//
//  WarningViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/17/24.
//
import Foundation

class WarningViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
    }

    var detectedSoundMessage: String {
        if let sound = appRootManager.detectedSound {
            return "\(sound) 소리가 감지되었습니다."
        } else {
            return "높은 신뢰도의 예기치 못한 소리가 감지되었습니다."
        }
    }

    func returnToHome() {
        appRootManager.currentRoot = .working
    }

    func autoTransitionToWorkingView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.appRootManager.currentRoot = .working
        }
    }
}
