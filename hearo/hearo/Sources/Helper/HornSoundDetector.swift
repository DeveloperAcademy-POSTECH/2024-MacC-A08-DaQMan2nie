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

class HornSoundDetector: NSObject, ObservableObject {
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var soundClassifier: HornSoundClassifier_V8? // 모델을 V8로 변경
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private var appRootManager: AppRootManager // appRootManager 속성 추가

    @Published var isRecording = false
    @Published var classificationResult = "녹음 시작 전"
    @Published var confidence: Double = 0.0 // 한 채널의 신뢰도 저장
    @Published var detectedHornSound = false // 소리 감지 여부를 나타내는 변수

    private var cancellables = Set<AnyCancellable>()

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        super.init()
        setupAudioSession()
        setupAudioEngine()
        setupSoundClassifier()
        
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

//    // MARK: - Background Notification
//    private func setupBackgroundNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(stopRecording), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(resumeRecording), name: UIApplication.willEnterForegroundNotification, object: nil)
//    }

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
            soundClassifier = try HornSoundClassifier_V8(configuration: config) // V8 모델 사용
            print("소리 분류기 설정 성공")
        } catch {
            print("소리 분류기 설정 실패: \(error.localizedDescription)")
        }
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

        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 8192, format: format) { [weak self] buffer, time in
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


//    @objc func resumeRecording() {
//        guard !isRecording else { return }
//        startRecording()
//        print("녹음 재개됨 (앱 포그라운드)")
//        
//        // 포그라운드 진입 시 라이브 액티비티 다시 시작
//        appRootManager.startLiveActivity(isWarning: false)
//    }
    
    // MARK: - Stop Recording

    @objc func stopRecording() {
        guard isRecording else { return }
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        streamAnalyzer = nil
        isRecording = false

//        print("녹음 중지됨 (앱 백그라운드)")
//        
//        // 백그라운드 진입 시 라이브 액티비티 중지
//        appRootManager.stopLiveActivity()


        print("오디오 엔진 중지 완료")
    }

    @objc func resumeRecording() {
        if !isRecording {
            print("녹음 재개")
            startRecording()
        }

    }

    // MARK: - Send Notification
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 발송 실패: \(error.localizedDescription)")
            } else {
                print("알림 발송 성공")
            }
        }
    }
}

extension HornSoundDetector: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }

        DispatchQueue.main.async {

            if let topClassification = result.classifications.first {
                print("최상위 분류: \(topClassification.identifier), 신뢰도: \(topClassification.confidence)")
                
                // 관심 있는 소리만 처리
                let relevantSounds = ["Bicyclebell", "Carhorn", "Siren"]
                if relevantSounds.contains(topClassification.identifier) {
                    self.classificationResult = topClassification.identifier
                    self.confidence = topClassification.confidence

                    if topClassification.confidence >= 0.99 {
                        print("⚠️ 신뢰도 1.0 이상 감지: \(topClassification.identifier), 신뢰도: \(topClassification.confidence)")
                        self.appRootManager.currentRoot = .warning // 경고 상태로 전환
                        self.appRootManager.detectedSound = topClassification.identifier
                    }
                } else {
                    print("관련 없는 소리 무시: \(topClassification.identifier)")
                }
            }
        }
    }
}
