//
//  WatchSessionManager.swift
//  HearoadWatch Watch App
//
//  Created by Pil_Gaaang on 10/28/24.
//
import Foundation
import WatchKit
import WatchConnectivity

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchSessionManager() // 싱글톤 인스턴스 생성
    
    @Published var alertMessage: String = " " // 기본 메시지
    @Published var isAlerting: Bool = false // 알림 상태 확인
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    // iOS에서 경고 메시지를 수신하는 메서드
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let alert = message["alert"] as? String {
            DispatchQueue.main.async {
                self.showAlert(with: alert)
            }
        }
    }
    
    // 이미지 이름을 반환하는 메서드
    func alertImageName() -> String {
        switch alertMessage {
        case "Carhorn":
            return "Car" // carhorn 이미지 이름
        case "Siren":
            return "Siren" // siren 이미지 이름
        case "Bicyclebell":
            return "Bicycle" // bicycle 이미지 이름
        default:
            return "exclamationmark.triangle.fill" // 기본 알림 아이콘
        }
    }

    // 3초 동안 알림 표시 후 기본 상태로 복구
    func showAlert(with message: String) {
        alertMessage = message
        isAlerting = true
        
        // 강한 진동 알림 발생
        playUrgentHapticPattern()
        
        // 3초 후에 기본 상태로 복구
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.resetAlert()
        }
    }

    // 긴급 상황을 위한 강한 진동 패턴
    func playUrgentHapticPattern() {
        // 반복 횟수 및 간격 설정
        let repeatCount = 30 // 진동 반복 횟수
        let interval: TimeInterval = 0.05 // 반복 간격 (0.1초)

        // 반복적으로 강한 진동을 재생하는 패턴
        for i in 0..<repeatCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + (interval * Double(i))) {
                WKInterfaceDevice.current().play(.failure) // 강한 피드백을 주는 진동
            }
        }
    }
    
    // 기본 상태로 복구하는 메서드
    func resetAlert() {
        alertMessage = "인식중"
        isAlerting = false
    }
    
    // WCSession 활성화 완료 시 호출되는 메서드
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("애플워치 - WCSession 활성화 완료. 상태: \(activationState.rawValue)")
        if let error = error {
            print("애플워치 - 활성화 오류: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let highestConfidenceSound = applicationContext["highestConfidenceSound"] as? String {
            DispatchQueue.main.async {
                self.showAlert(with: highestConfidenceSound) // 수신한 소리를 알림으로 표시
                print("애플워치 - applicationContext 데이터 수신: \(highestConfidenceSound)")
            }
        }
    }
}
