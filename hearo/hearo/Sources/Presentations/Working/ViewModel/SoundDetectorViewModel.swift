//
//  SoundDetectorViewModel.swift
//  hearo
//
//  Created by 규북 on 10/13/24.
//
import Foundation
import Combine

class SoundDetectorViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var classificationResults: [String] = Array(repeating: "녹음 시작 전", count: 4)
    @Published var detectedHornSounds: [Bool] = Array(repeating: false, count: 4)
    
    private var soundDetectors: [HornSoundDetector] = []
    private var mlConfidences: [Double] = Array(repeating: 0.0, count: 4) // 각 마이크의 신뢰도를 저장
    private var cancellables = Set<AnyCancellable>()
    private var appRootManager: AppRootManager
    
    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
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
                        self.checkAllConfidences() // 각 채널의 신뢰도를 확인
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
            }
        }
    }
    
    func startRecording() {
        for detector in soundDetectors {
            detector.startRecording()
        }
    }
    
    func stopRecording() {
        for detector in soundDetectors {
            detector.stopRecording()
        }
    }
}
