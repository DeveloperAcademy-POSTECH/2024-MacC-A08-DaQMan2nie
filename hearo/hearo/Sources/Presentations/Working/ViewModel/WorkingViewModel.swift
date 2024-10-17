//
//  WorkingViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//

import Foundation

class WorkingViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var soundDetectorViewModel: SoundDetectorViewModel
    

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetectorViewModel = SoundDetectorViewModel(appRootManager: appRootManager)
        
    }

    var classificationResult: String {
        // 모든 채널의 분류 결과를 출력
        var results = ""
        for (index, result) in soundDetectorViewModel.classificationResults.enumerated() {
            results += "채널 \(index + 1): \(result)\n"
        }
        return results
    }

    func startRecording() {
        soundDetectorViewModel.startRecording()
        print("녹음 시작")
    }

    func stopRecording() {
        soundDetectorViewModel.stopRecording()
        print("녹음 중지")
    }

    func finishRecording() {
        appRootManager.currentRoot = .finish
        stopRecording()
    }
}
