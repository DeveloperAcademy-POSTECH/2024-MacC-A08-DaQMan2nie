//
//  WorkingViewModel.swift
//  hearo
//
//  Created by Pil_Gaaang on 10/5/24.
//
import Foundation
import AVFoundation
import Combine // Combine 프레임워크 임포트
import SwiftUI // SwiftUI 프레임워크 임포트


class WorkingViewModel: ObservableObject {
    @Published var appRootManager: AppRootManager
    @Published var soundDetectorViewModel: SoundDetectorViewModel
    
    init(appRootManager: AppRootManager) {
        self.appRootManager = appRootManager
        self.soundDetectorViewModel = SoundDetectorViewModel(appRootManager: appRootManager)

        //AVAudioSession 설정
        configureAudioSession()
    }

    func configureAudioSession() {
           do {
               let audioSession = AVAudioSession.sharedInstance()
               try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
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
        print("WorkingViewModel: startRecording() 호출됨")
        soundDetectorViewModel.startRecording()
        print("WorkingViewModel: 녹음 시작 완료")

        // 라이브 액티비티 시작
        appRootManager.startLiveActivity(isWarning: false)
    }

    func stopRecording() {
        print("WorkingViewModel: stopRecording() 호출됨")
        soundDetectorViewModel.stopRecording()
        print("녹음 중지 완료")
        
        // 라이브 액티비티 중지
        appRootManager.stopLiveActivity()
    }

    func finishRecording() {
        appRootManager.currentRoot = .finish
        stopRecording()
    }

    func triggerWarning() {
        appRootManager.updateLiveActivity(isWarning: true)
        print("경고 상태 업데이트됨")
    }
}
