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

    @Published var classificationResult: String = "녹음 시작 전" // 단일 채널 결과
    @Published var detectedHornSound: Bool = false
    @Published var mlConfidence: Double = 0.0 // 단일 채널 신뢰도

    private var soundDetector: HornSoundDetector // 단일 채널 감지기
    private var cancellables = Set<AnyCancellable>()
    private var appRootManager: AppRootManager

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
        // SoundDetector의 `isRecording` 상태 연결
        soundDetector.$isRecording
            .assign(to: \.isRecording, on: self)
            .store(in: &cancellables)

        // SoundDetector의 `classificationResult` 상태 연결
        soundDetector.$classificationResult
            .sink { [weak self] result in
                self?.classificationResult = result
            }
            .store(in: &cancellables)

        // SoundDetector의 `detectedHornSound` 상태 연결
        soundDetector.$detectedHornSound
            .sink { [weak self] detected in
                self?.detectedHornSound = detected
            }
            .store(in: &cancellables)

        // SoundDetector의 신뢰도 연결
        soundDetector.$confidence
            .sink { [weak self] confidence in
                self?.mlConfidence = confidence
                self?.checkConfidence()
                self?.sendWarningToWatch() // classificationResult가 변경될 때 Apple Watch에 실시간으로 경고 전송

            }
            .store(in: &cancellables)
    }


    private func checkConfidence() {
        // 신뢰도가 0.99 이상이면 경고 전환
        if mlConfidence >= 1.0 {
            DispatchQueue.main.async {
                self.appRootManager.currentRoot = .warning
                self.sendWarningToWatch() // 애플워치에 경고 전송
            }
        }
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
        print("WCSession 활성화 완료. 상태: \(activationState)")

    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {

        print("MLWCSession 비활성화됨")

    }
    
    func sessionDidDeactivate(_ session: WCSession) {

        print("MLWCSession 비활성화됨. 다시 활성화")

        WCSession.default.activate()
    }
}
