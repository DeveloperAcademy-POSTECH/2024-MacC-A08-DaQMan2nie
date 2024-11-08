
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
import UIKit
import Combine

class HornSoundDetector: NSObject, ObservableObject {

    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var soundClassifier: HornSoundClassifier_V11?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    private var appRootManager: AppRootManager // appRootManager 속성 추가

    @Published var isRecording = false
    @Published var classificationResult = "녹음 시작 전"
    private var cancellables = Set<AnyCancellable>()
    
    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        super.init()
        setupAudioSession()
        setupAudioEngine()
        setupSoundClassifier()
        NotificationCenter.default.addObserver(self, selector: #selector(stopRecording), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setPreferredInputNumberOfChannels(1) // 모노 입력으로 설정
            try audioSession.setActive(true)
        } catch {
            print("오디오 세션 설정 실패: \(error)")
        }
    }

    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        let monoFormat = AVAudioFormat(commonFormat: format.commonFormat, sampleRate: format.sampleRate, channels: 1, interleaved: format.isInterleaved)
        streamAnalyzer = SNAudioStreamAnalyzer(format: monoFormat ?? format)
    }

    private func setupSoundClassifier() {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .cpuOnly
            soundClassifier = try HornSoundClassifier_V11(configuration: config)
            print("CPU 전용 설정으로 소리 분류기 생성 성공")
        } catch {
            print("소리 분류기 생성 실패: \(error)")
        }
    }

    func startRecording() {
        guard !isRecording else {
            print("녹음이 이미 시작된 상태입니다.")
            return
        }

        guard let streamAnalyzer = streamAnalyzer, let soundClassifier = soundClassifier else {
            print("스트림 분석기 또는 소리 분류기 생성 실패")
            return
        }

        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try streamAnalyzer.add(request, withObserver: self)
        } catch {
            print("분류 요청 생성 실패: \(error)")
            return
        }

        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 8192, format: format) { [weak self] buffer, time in
            self?.streamAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
        }

        audioEngine.prepare()
        do {
            try audioEngine.start()
            isRecording = true
            print("오디오 엔진 시작됨")
            
        } catch {
            print("오디오 엔진 시작 실패: \(error)")
        }
    }

    @objc func stopRecording() {
        guard isRecording else {
            print("녹음이 이미 중지된 상태입니다.")
            return
        }
        
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        streamAnalyzer = nil
        isRecording = false
        print("오디오 엔진 중지됨")
    }

    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
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
            if let topClassification = result.classifications.first, topClassification.confidence >= 0.99 {
                let isRelevantSound = ["Bicyclebell", "Carhorn", "Siren"].contains(topClassification.identifier)
                if isRelevantSound {
                    self.classificationResult = topClassification.identifier
                    self.appRootManager.detectedSound = topClassification.identifier
                    self.appRootManager.currentRoot = .warning // 루트 변경
                    print("감지된 소리: \(topClassification.identifier) - 신뢰도: \(topClassification.confidence)")
                }
            } else {
                print("신뢰도 부족 또는 관련 없는 소리 감지됨")
            }
        }
    }
}
