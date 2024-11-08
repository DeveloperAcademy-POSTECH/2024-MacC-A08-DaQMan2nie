//
//  SoundDetectorViewModel.swift
//  hearo
//
//  Created by 규북 on 10/13/24.
//
import Foundation
import Combine
import WatchConnectivity

class SoundDetectorViewModel: NSObject, ObservableObject, WCSessionDelegate {
    @Published var isRecording = false
    @Published var classificationResult: String = "녹음 시작 전"
    
    private var soundDetector: HornSoundDetector
    private var cancellables = Set<AnyCancellable>()
    private var appRootManager: AppRootManager
    private var isActivityActive = false

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetector = HornSoundDetector(appRootManager: appRootManager) // 단일 soundDetector 인스턴스
        super.init()
        
        // `WCSession` 설정
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        setupBindings()
    }
    
    private func setupBindings() {
        soundDetector.$isRecording
            .assign(to: \.isRecording, on: self)
            .store(in: &cancellables)
        
        soundDetector.$classificationResult
            .sink { [weak self] result in
                self?.classificationResult = result
            }
            .store(in: &cancellables)
    }
    
    private func sendWarningToWatch() {
        guard WCSession.default.isReachable else {
            print("애플워치가 연결되지 않음")
            return
        }

        let message = ["alert": classificationResult]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("애플워치로 경고 메시지 전송 오류: \(error.localizedDescription)")
        }
    }
    
    func startRecording() {
        soundDetector.startRecording()
    }
    
    func stopRecording() {
        soundDetector.stopRecording()
    }
    
    // 필수 WCSessionDelegate 메서드 구현
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("MLWCSession 활성화 완료. 상태: \(activationState)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("MLWCSession 비활성화됨")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("MLWCSession 비활성화됨. 다시 활성화")
        WCSession.default.activate()
    }
}
