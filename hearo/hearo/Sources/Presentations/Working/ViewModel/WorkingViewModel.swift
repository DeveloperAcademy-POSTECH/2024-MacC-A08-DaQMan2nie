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

        //AVAudioSession 설정
        configureAudioSession()
    }

    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default) // 옵션 제거
            try audioSession.setActive(true)
            print("오디오 세션이 성공적으로 설정되었습니다.")
        } catch {
            print("오디오 세션 설정 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    var classificationResult: String {
        // 모든 채널의 분류 결과를 출력
        var results = ""
        for (index, result) in soundDetectorViewModel.classificationResults.enumerated() {
            results += "채널 \(index + 1): \(result)\n"
        }
        return results


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

