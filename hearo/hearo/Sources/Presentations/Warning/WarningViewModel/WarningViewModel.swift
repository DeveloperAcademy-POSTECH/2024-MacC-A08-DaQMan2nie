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

    func alertImageName() -> String {
           switch appRootManager.detectedSound {
           case "Carhorn":
               return "Car"
           case "Siren":
               return "Siren"
           case "Bicyclebell":
               return "Bicycle"
           default:
               return "exclamationmark.triangle.fill" // 기본 아이콘
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
