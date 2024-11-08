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
//import UserNotifications
import UIKit
import Combine

class HornSoundDetector: NSObject, ObservableObject {

    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var soundClassifier: HornSoundClassifier_V11?
    private var streamAnalyzer: SNAudioStreamAnalyzer?
    
    @Published var isRecording = false
    @Published var classificationResult = "녹음 시작 전"
    @Published var detectedHornSound = false
    @Published var topClassification: SNClassification? // 가장 높은 분류 저장
    @Published var mlConfidences: [Double] = Array(repeating: 0.0, count: 4) // 각 채널의 신뢰도 배열
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        setupAudioSession()
        setupAudioEngine()
        setupSoundClassifier()
//        checkNotificationPermission()
        
//         앱이 백그라운드로 전환될 때 녹음을 중지하도록 옵저버 설정
        NotificationCenter.default.addObserver(self, selector: #selector(stopRecording), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
//            print("오디오 세션 설정 성공")
        } catch {
            print("오디오 세션 설정 실패: \(error)")
        }
    }
  
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        print("오디오 엔진 설정")
    }
    
    private func setupSoundClassifier() {
        do {
            let config = MLModelConfiguration()
//            config.computeUnits = .cpuOnly
            config.computeUnits = .all
            soundClassifier = try HornSoundClassifier_V11(configuration: config)
//            print("CPU 전용 설정으로 소리 분류기 생성 성공")
            print("모든 하드웨어 설정으로 소리 분류기 생성 성공")
        } catch {
            print("소리 분류기 생성 실패: \(error)")
        }
    }
    
//    private func checkNotificationPermission() {
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            switch settings.authorizationStatus {
//            case .notDetermined:
//                self.requestNotificationPermission()
//            case .denied:
//                print("알림 권한이 거부되었습니다. 설정에서 권한을 변경해주세요.")
//            case .authorized, .provisional, .ephemeral:
//                print("알림 권한이 허용되었습니다.")
//            @unknown default:
//                break
//            }
//        }
//    }
    
//    private func requestNotificationPermission() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
//            if granted {
//                print("알림 권한이 허용되었습니다.")
//            } else if let error = error {
//                print("알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
//            }
//        }
//    }
    
    func startRecording() {
        guard !isRecording else {
            print("녹음이 이미 시작된 상태입니다.")
            return
        }
        
        let format = inputNode.outputFormat(forBus: 0)
        streamAnalyzer = SNAudioStreamAnalyzer(format: format)
        
        guard let streamAnalyzer = streamAnalyzer,
              let soundClassifier = soundClassifier else {
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
    

}

extension HornSoundDetector: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else { return }
        
        let topClassifications = result.classifications.prefix(3)
        
        DispatchQueue.main.async {
            // 첫 번째 분류를 가장 신뢰도 높은 것으로 설정
            if let topClassification = topClassifications.first(where: { classification in
              return classification.identifier == "Bicyclebell" || classification.identifier == "Carhorn" || classification.identifier == "Siren" || classification.identifie == "etc"
            }) {
                self.topClassification = topClassification // 가장 높은 분류 저장
                self.classificationResult = topClassification.identifier // 소리 종류만 저장
            }

            for (index, classification) in topClassifications.enumerated() {
                if classification.identifier == "Bicyclebell" || classification.identifier == "Carhorn" || classification.identifier == "Siren" {
                    // 경적 및 사이렌 소리 감지
                    if classification.confidence >= 1.0 {
                        self.mlConfidences[index] = classification.confidence
                      print("\(classification.identifier) ")
                    }
                }
            }
        }
    }
}
