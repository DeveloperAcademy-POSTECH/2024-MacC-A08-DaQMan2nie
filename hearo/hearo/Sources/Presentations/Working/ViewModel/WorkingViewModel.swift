//
//  WorkingViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//
import Foundation
import Combine
import SwiftUI
import AVFoundation
//import AudioToolbox

class WorkingViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var soundDetectorViewModel: SoundDetectorViewModel
    private var isRecording: Bool = false // 녹음 상태를 추적하는 변수
    private var cancellables = Set<AnyCancellable>() // Combine 구독을 저장하는 변수 추가

    
    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetectorViewModel = SoundDetectorViewModel(appRootManager: appRootManager)
        
        // AVAudioSession 설정
        configureAudioSession()
        // 감지된 소리 이벤트를 관찰하고 WarningView로 전환
        observeSoundDetection()
    }
    
    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            print("오디오 세션이 성공적으로 설정되었습니다.")
        } catch {
            print("오디오 세션 설정 중 오류 발생: \(error.localizedDescription)")
        }
    }

    private func observeSoundDetection() {
            soundDetectorViewModel.$classificationResult
                .sink { [weak self] result in
                    guard let self = self else { return }
                    if result != "녹음 시작 전" && result != "" {
                        print("감지된 소리에 따라 WarningView로 전환합니다.")
                        self.appRootManager.currentRoot = .warning
                    }
                }
                .store(in: &cancellables)
        }

    func startRecording() {
        guard !isRecording else {
            print("녹음이 이미 진행 중입니다.")
            return
        }
        print("WorkingViewModel: startRecording() 호출됨")
        soundDetectorViewModel.startRecording()
        print("WorkingViewModel: 녹음 시작 완료")

        appRootManager.startLiveActivity(isWarning: false)
    }

    func stopRecording() {
        guard isRecording else {
            print("녹음이 이미 중지된 상태입니다.")
            return
        }
        print("WorkingViewModel: stopRecording() 호출됨")
        soundDetectorViewModel.stopRecording()
        print("녹음 중지 완료")
        
        appRootManager.stopLiveActivity()
    }

    func finishRecording() {
        triggerErrorHaptic()
        appRootManager.currentRoot = .finish
    }
}
