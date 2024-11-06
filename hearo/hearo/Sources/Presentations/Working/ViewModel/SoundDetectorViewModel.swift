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
    @Published var classificationResults: [String] = Array(repeating: "녹음 시작 전", count: 4)
    @Published var detectedHornSounds: [Bool] = Array(repeating: false, count: 4)
    
    private var soundDetectors: [HornSoundDetector] = []
    private var mlConfidences: [Double] = Array(repeating: 0.0, count: 4)
    private var cancellables = Set<AnyCancellable>()
    private var appRootManager: AppRootManager
    private var isActivityActive = false

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        super.init()
        
        // `WCSession` 설정
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        for _ in 0..<4 {
            let soundDetector = HornSoundDetector()
            soundDetectors.append(soundDetector)
        }
        setupBindings()
    }
    
    private func setupBindings() {
        for (index, soundDetector) in soundDetectors.enumerated() {
            soundDetector.$isRecording
                .assign(to: \.isRecording, on: self)
                .store(in: &cancellables)
            
            soundDetector.$classificationResult
                .sink { [weak self] result in
                    self?.classificationResults[index] = result
                }
                .store(in: &cancellables)
            
            soundDetector.$detectedHornSound
                .sink { [weak self] detected in
                    self?.detectedHornSounds[index] = detected
                }
                .store(in: &cancellables)
            
            soundDetector.$topClassification
                .sink { [weak self] topClassification in
                    guard let self = self else { return }
                    if let classification = topClassification {
                        self.mlConfidences[index] = classification.confidence
                        self.checkAllConfidences()
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func checkAllConfidences() {
        // 모든 마이크의 신뢰도가 0.99 이상인지 확인
        if mlConfidences.allSatisfy({ $0 >= 0.99 }) {
            DispatchQueue.main.async {
                self.appRootManager.currentRoot = .warning
                self.sendWarningToWatch() // 애플워치에 경고 전송
                self.updateApplicationContext() // 애플워치에 데이터 전송
            }
        }
    }
    
    private func getHighestConfidenceSound() -> String? {
        if let highestConfidenceIndex = mlConfidences.enumerated().max(by: { $0.element < $1.element })?.offset,
           highestConfidenceIndex < classificationResults.count {
            return classificationResults[highestConfidenceIndex]
        }
        return nil
    }
    
    private func updateApplicationContext() {
        do {
            if let highestConfidenceSound = getHighestConfidenceSound() {
                let context = ["highestConfidenceSound": highestConfidenceSound]
                try WCSession.default.updateApplicationContext(context)
                print("applicationContext 데이터 전송 성공: \(context)")
            }
        } catch {
            print("applicationContext 데이터 전송 실패: \(error.localizedDescription)")
        }
    }
    
    private func sendWarningToWatch() {
        guard WCSession.default.isReachable else {
            print("애플워치가 연결되지 않음")
            return
        }
        
        if let highestConfidenceSound = getHighestConfidenceSound() {
            let message = ["alert": highestConfidenceSound]
            
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("애플워치로 경고 메시지 전송 오류: \(error.localizedDescription)")
            }
        } else {
            print("경고를 보낼 신뢰도 높은 소리가 없음")
        }
    }
    
    func toggleRecording(start: Bool) {
        for detector in soundDetectors {
            if start {
                detector.startRecording()
            } else {
                detector.stopRecording()
            }
        }
    }
    
    func startRecording() {
        toggleRecording(start: true)
    }
    
    func stopRecording() {
        toggleRecording(start: false)
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
