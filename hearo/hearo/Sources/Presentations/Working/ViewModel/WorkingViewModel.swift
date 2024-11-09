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
import AudioToolbox

class WorkingViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var soundDetectorViewModel: SoundDetectorViewModel
    private var isRecording: Bool = false // 녹음 상태를 추적하는 변수

    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetectorViewModel = SoundDetectorViewModel(appRootManager: appRootManager)
        configureAudioSession() // AVAudioSession 설정
    }

    // 오디오 세션 설정
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
    
    // 모든 채널의 분류 결과를 출력
    var classificationResult: String {
        var results = ""
        for (index, result) in soundDetectorViewModel.classificationResults.enumerated() {
            results += "채널 \(index + 1): \(result)\n"
        }
        return results
    }

    // 녹음 시작
    func startRecording() {
        guard !isRecording else {
            print("녹음이 이미 진행 중입니다.")
            return
        }
        isRecording = true
        print("WorkingViewModel: startRecording() 호출됨")
        soundDetectorViewModel.startRecording()
        print("WorkingViewModel: 녹음 시작 완료")

        appRootManager.startLiveActivity(isWarning: false) // 녹음 시작 시 라이브 액티비티 활성화
    }

    // 녹음 중지
    func stopRecording() {
        guard isRecording else {
            print("녹음이 이미 중지된 상태입니다.")
            return
        }
        isRecording = false
        print("WorkingViewModel: stopRecording() 호출됨")
        soundDetectorViewModel.stopRecording()
        print("녹음 중지 완료")

        appRootManager.stopLiveActivity() // 녹음 중지 시 라이브 액티비티 비활성화
    }

    // 녹음 완료 및 종료 화면으로 이동
    func finishRecording() {
        stopRecording() // 녹음 중지 메서드 호출
        triggerErrorHaptic()
        appRootManager.currentRoot = .finish // 종료 화면으로 전환
    }

    // 햅틱 피드백 트리거
    private func triggerErrorHaptic() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
