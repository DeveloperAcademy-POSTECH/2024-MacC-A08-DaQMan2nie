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
    
    private let soundDetector = HornSoundDetector()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
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
    }
    
    func startRecording() {
        soundDetector.startRecording()
    }
    
    func stopRecording() {
        soundDetector.stopRecording()
    }
}

