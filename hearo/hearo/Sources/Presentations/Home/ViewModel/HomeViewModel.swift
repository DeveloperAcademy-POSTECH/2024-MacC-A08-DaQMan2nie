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
        updateCurrentDate()
    }

    func updateCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy. MM. dd. EEEE"
        currentDate = dateFormatter.string(from: Date())
    }

    func startWorking() {
        appRootManager.currentRoot = .working
    }
}
