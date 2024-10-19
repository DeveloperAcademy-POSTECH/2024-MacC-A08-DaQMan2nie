//
//  WorkingViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//
import Foundation
import Combine // Combine 프레임워크 임포트
import SwiftUI // SwiftUI 프레임워크 임포트

class WorkingViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var soundDetectorViewModel: SoundDetectorViewModel
    
    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetectorViewModel = SoundDetectorViewModel(appRootManager: appRootManager)
    }

    func startRecording() {
        print("WorkingViewModel: startRecording() 호출됨")
        soundDetectorViewModel.startRecording()
        print("WorkingViewModel: 녹음 시작 완료")

        // 라이브 액티비티 시작
        appRootManager.startLiveActivity(isWarning: false)
    }

    func stopRecording() {
        print("WorkingViewModel: stopRecording() 호출됨")
        soundDetectorViewModel.stopRecording()
        print("녹음 중지 완료")
        
        // 라이브 액티비티 중지
        appRootManager.stopLiveActivity()
    }

    func finishRecording() {
        appRootManager.currentRoot = .finish
        stopRecording()
    }

    func triggerWarning() {
        appRootManager.updateLiveActivity(isWarning: true)
        print("경고 상태 업데이트됨")
    }
}
