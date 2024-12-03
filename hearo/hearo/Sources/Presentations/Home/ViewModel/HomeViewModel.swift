//
//  HomeViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/4/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var currentDate: String = ""

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
    }

    func startWorking() {
        print("HomeViewModel: startWorking() 호출됨")
        appRootManager.currentRoot = .working
        print("HomeViewModel: appRootManager.currentRoot = \(appRootManager.currentRoot)")
    }
}
