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
    
    @Published var alertMessage: String = "인식중" // 기본 메시지
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
    
    // 3초 동안 알림 표시 후 기본 상태로 복구
    func showAlert(with message: String) {
        alertMessage = message
        isAlerting = true
        WKInterfaceDevice.current().play(.notification) // 진동 알림 발생
        
        // 3초 후에 기본 상태로 복구
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.resetAlert()
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
}
