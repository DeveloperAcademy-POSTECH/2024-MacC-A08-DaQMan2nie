//
//  HornSoundDetector.swift
//  hearo
//
//  Created by 규북 on 10/13/24.
//

import Foundation
import AVFoundation
import CoreML
import SoundAnalysis
import UserNotifications
import Combine
import WatchConnectivity

class HornSoundDetector: NSObject, ObservableObject, WCSessionDelegate, SNResultsObserving {
   
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var soundClassifier: HornSoundClassifier_V8?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private var appRootManager: AppRootManager

    @Published var isRecording = false
    @Published var classificationResult = "녹음 시작 전"
    @Published var confidence: Double = 0.0

    private let relevantSounds = ["Bicyclebell", "Carhorn", "Siren"] // 처리할 소리
    private var cancellables = Set<AnyCancellable>()

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        super.init()
        setupAudioSession()
        setupAudioEngine()
        setupSoundClassifier()
        activateWCSession()
    }

    // MARK: - Audio Session Setup
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .mixWithOthers])
            try audioSession.setActive(true)
            print("오디오 세션 설정 성공")
        } catch {
            print("오디오 세션 설정 실패: \(error.localizedDescription)")
        }
    }

    // MARK: - Audio Engine Setup
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        guard let monoFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: format.sampleRate, channels: 1, interleaved: format.isInterleaved) else {
            print("오디오 포맷 생성 실패")
            return
        }
        streamAnalyzer = SNAudioStreamAnalyzer(format: monoFormat)
    }

    // MARK: - Sound Classifier Setup
    private func setupSoundClassifier() {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .cpuOnly
            soundClassifier = try HornSoundClassifier_V8(configuration: config)
            print("소리 분류기 설정 성공")
        } catch {
            print("소리 분류기 설정 실패: \(error.localizedDescription)")
        }
    }

    // MARK: - WCSession Activation
    private func activateWCSession() {
        guard WCSession.isSupported() else {
            print("WCSession이 지원되지 않음")
            return
        }
        let session = WCSession.default
        session.delegate = self
        session.activate()
        print("WCSession 활성화 요청 완료")
    }

    // MARK: - Start Recording
    func startRecording() {
        guard !isRecording else {
            print("녹음이 이미 진행 중입니다.")
            return
        }
        guard let streamAnalyzer = streamAnalyzer, let soundClassifier = soundClassifier else {
            print("분석기 또는 소리 분류기 초기화 실패")
            return
        }
        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try streamAnalyzer.add(request, withObserver: self)
        } catch {
            print("분류 요청 추가 실패: \(error.localizedDescription)")
            return
        }
        inputNode.installTap(onBus: 0, bufferSize: 8192, format: inputNode.outputFormat(forBus: 0)) { [weak self] buffer, time in
            self?.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }
        do {
            try audioEngine.start()
            isRecording = true
            print("오디오 엔진 시작됨")
        } catch {
            print("오디오 엔진 시작 실패: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        guard isRecording else { return }
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        isRecording = false
        print("오디오 엔진 중지 완료")
    }

    // MARK: - SNResultsObserving
    @objc(request:didProduceResult:) func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        DispatchQueue.main.async {
            if let topClassification = result.classifications.first {
                print("최상위 분류: \(topClassification.identifier), 신뢰도: \(topClassification.confidence)")

                // 관심 있는 소리만 처리
                if self.relevantSounds.contains(topClassification.identifier), topClassification.confidence >= 0.99 {
                    self.triggerWarningActions(for: topClassification.identifier)
                } else {
                    print("관련 없는 소리 무시: \(topClassification.identifier)")
                }
            }
        }
    }

    // MARK: - Trigger Warning Actions
    private func triggerWarningActions(for sound: String) {
        self.appRootManager.currentRoot = .warning
        self.appRootManager.detectedSound = sound
        sendWarningToWatch(alert: sound)
        print("⚠️ 경고 알림 처리 완료: \(sound)")
    }

    private func sendWarningToWatch(alert: String) {
        guard WCSession.isSupported() else {
            print("WCSession이 지원되지 않음")
            return
        }

        guard WCSession.default.activationState == .activated else {
            print("WCSession이 활성화되지 않음, 재활성화 시도")
            WCSession.default.activate()
            return
        }

        guard WCSession.default.isReachable else {
            print("애플워치가 연결되지 않음")
            return
        }

        let message = ["alert": alert]
        WCSession.default.sendMessage(message, replyHandler: { response in
            print("✅ 애플워치로 경고 메시지 전송 성공: \(alert)")
        }) { error in
            print("❌ 애플워치로 경고 메시지 전송 실패: \(error.localizedDescription)")
        }
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession 활성화 완료: \(activationState.rawValue)")
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        // 세션이 비활성화될 때 호출됩니다.
        print("WCSession 비활성화됨")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // 세션이 비활성화된 후 다시 활성화를 준비합니다.
        print("WCSession 비활성화됨. 다시 활성화 준비")
        WCSession.default.activate()
    }
    
}
