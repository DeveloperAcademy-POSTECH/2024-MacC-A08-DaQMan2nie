//
//  SoundDetectorViewModel.swift
//  hearo
//
//  Created by 규북 on 10/13/24.
//
import Foundation
import Combine
import WatchConnectivity

class SoundDetectorViewModel: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var classificationResult: String = "녹음 시작 전"
    @Published var confidence: Double = 0.0

    private var hornSoundDetector: HornSoundDetector
    private var appRootManager: AppRootManager
    private var cancellables = Set<AnyCancellable>()

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.hornSoundDetector = HornSoundDetector(appRootManager: appRootManager)
        super.init()
        setupBindings()
    }

    private func setupBindings() {
        hornSoundDetector.$isRecording
            .assign(to: \.isRecording, on: self)
            .store(in: &cancellables)

        hornSoundDetector.$classificationResult
            .assign(to: \.classificationResult, on: self)
            .store(in: &cancellables)

        hornSoundDetector.$confidence
            .assign(to: \.confidence, on: self)
            .store(in: &cancellables)
    }

    func startRecording() {
        hornSoundDetector.startRecording()
    }

    func stopRecording() {
        hornSoundDetector.stopRecording()
    }
}
