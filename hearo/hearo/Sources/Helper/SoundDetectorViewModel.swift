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
    private var lastMessageSent: String? // 마지막으로 보낸 메시지 기록

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetector = HornSoundDetector(appRootManager: appRootManager)
        super.init()

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
                self?.sendWarningToWatch()
            }
            .store(in: &cancellables)
    }

    /// iOS에서 워치로 데이터를 전송
    func sendWarningToWatch() {
        guard lastMessageSent != classificationResult else { return }
        lastMessageSent = classificationResult

        // `WCSession` 활성화 상태 확인
        guard WCSession.default.activationState == .activated else {
            print("WCSession이 활성화되지 않음")
            return
        }

        // 메시지를 보내거나 ApplicationContext 업데이트
        let message = ["alert": classificationResult]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("sendMessage 실패: \(error.localizedDescription)")
        }
    }

    func startRecording() {
        guard !isRecording else {
            print("녹음이 이미 진행 중입니다.")
            return
        }
        soundDetector.startRecording()
        isRecording = true
    }

    func stopRecording() {
        guard isRecording else {
            print("녹음이 이미 중지된 상태입니다.")
            return
        }
        soundDetector.stopRecording()
        isRecording = false
    }

    // 필수 `WCSessionDelegate` 메서드
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("iOS - WCSession 활성화 완료. 상태: \(activationState.rawValue)")
        if let error = error {
            print("iOS - WCSession 활성화 오류: \(error.localizedDescription)")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("iOS - WCSession 비활성화됨")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("iOS - WCSession 비활성화됨. 다시 활성화")
        WCSession.default.activate()
    }
}
