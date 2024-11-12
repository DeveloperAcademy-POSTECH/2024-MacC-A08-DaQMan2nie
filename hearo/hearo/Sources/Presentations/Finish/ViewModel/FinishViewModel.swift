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
    private var hornSoundDetector: HornSoundDetector // HornSoundDetector 사용

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.hornSoundDetector = HornSoundDetector(appRootManager: appRootManager)
        
        // FinishViewModel 생성 시 녹음 종료 호출
        self.stopRecording()
        goToHomeWithDelay()
    }

    private func goToHomeWithDelay() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            triggerSuccessHaptic()
            self?.appRootManager.currentRoot = .home
        }
    }
    
    func stopRecording() {
        print("FinishViewModel: stopRecording() 호출됨")
        hornSoundDetector.stopRecording() // HornSoundDetector에서 처리
        print("녹음 중지 완료")
        appRootManager.stopLiveActivity() // 녹음 중지 시 라이브 액티비티 비활성화
    }
}
