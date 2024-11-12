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
import UIKit



//import AudioToolbox


class WorkingViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var soundDetectorViewModel: SoundDetectorViewModel
    private var isRecording: Bool = false // 녹음 상태를 추적하는 변수
    private var cancellables = Set<AnyCancellable>() // Combine 구독을 저장하는 변수 추가
    private var hornSoundDetector: HornSoundDetector // HornSoundDetector 사용

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetectorViewModel = SoundDetectorViewModel(appRootManager: appRootManager)
        self.hornSoundDetector = HornSoundDetector(appRootManager: appRootManager)

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
                print("observeSoundDetection에서 classificationResult: \(result)")
                if result != "녹음 시작 전" && result != "" {
                    self.appRootManager.currentRoot = .warning
                    print("감지된 소리에 따라 WarningView로 전환")
                }
            }
            .store(in: &cancellables)

    }

    // 녹음 시작
    func startRecording() {
        guard !isRecording else {
            print("녹음이 이미 진행 중입니다.")
            return
        }
//fix 
         isRecording = true
//fix 
        print("WorkingViewModel: startRecording() 호출됨")
        hornSoundDetector.startRecording() // HornSoundDetector에서 처리
        print("WorkingViewModel: 녹음 시작 완료")

    }

    // 녹음 중지
    func stopRecording() {
        guard isRecording else {
            print("녹음이 이미 중지된 상태입니다.")
            return
        }
//fix 
         isRecording = false
//fix 
        print("WorkingViewModel: stopRecording() 호출됨")
        hornSoundDetector.stopRecording() // HornSoundDetector에서 처리
        print("녹음 중지 완료")
        appRootManager.stopLiveActivity() // 녹음 중지 시 라이브 액티비티 비활성화

    }

    // 녹음 완료 및 종료 화면으로 이동
    func finishRecording() {
        stopRecording() // 녹음 중지 메서드 호출
        appRootManager.currentRoot = .finish // 종료 화면으로 전환
    }


    // 햅틱 피드백 트리거
    private func triggerErrorHaptic() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

}
extension WorkingViewModel {
    // 움직임에 따라 햅틱 피드백 트리거
    func triggerDynamicHapticFeedback(for offset: CGFloat, targetOffset: CGFloat) {
        let intensity = min(max(offset / targetOffset, 0), 1.0) // 0~1 사이 값으로 제한
        DispatchQueue.global(qos: .userInitiated).async {
            HapticManager.shared.triggerImpact(intensity: intensity)
        }
    }
    
    // 강한 햅틱 피드백
    func triggerFinalHapticFeedback() {
        DispatchQueue.main.async {
            HapticManager.shared.triggerNotification(type: .success)
        }
    }
}
