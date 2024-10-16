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
    @Published var classificationResult = "녹음 시작 전"
    @Published var detectedHornSound = false
    
    
    private let soundDetector: HornSoundDetector
    private var cancellables = Set<AnyCancellable>()
    private var appRootManager: AppRootManager
    
    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetector = HornSoundDetector()
        setupBindings()
    }
    
    private func setupBindings() {
        soundDetector.$isRecording
            .assign(to: \.isRecording, on: self)
            .store(in: &cancellables)
        
        soundDetector.$classificationResult
            .assign(to: \.classificationResult, on: self)
            .store(in: &cancellables)
        
        soundDetector.$detectedHornSound
            .assign(to: \.detectedHornSound, on: self)
            .store(in: &cancellables)
        
        soundDetector.$topClassification
            .sink { [weak self] topClassification in
                // "etc"가 아닌 소리면서 신뢰도가 0.99 이상이면 WarningView로 전환
                if let classification = topClassification,
                   classification.identifier != "etc" && classification.confidence >= 0.999 {
                    self?.appRootManager.currentRoot = .warning
                }
            }
            .store(in: &cancellables)
    }
    
    func startRecording() {
        soundDetector.startRecording()
    }
    
    func stopRecording() {
        soundDetector.stopRecording()
    }
}
