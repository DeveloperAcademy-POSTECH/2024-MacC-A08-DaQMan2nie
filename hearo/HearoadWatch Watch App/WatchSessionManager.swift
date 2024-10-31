//
//  WatchSessionManager.swift
//  HearoadWatch Watch App
//
//  Created by Pil_Gaaang on 10/28/24.
//
import Foundation
import WatchKit
import WatchConnectivity

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate{
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        switch reason {
        case .expired:
            print("세션이 만료되었습니다.")
        default:
            print("알 수 없는 이유로 세션이 만료되었습니다.")
        }
        
        if let error = error {
            print("세션 만료 오류: \(error.localizedDescription)")
        }
        
        // 세션 만료 후 백그라운드 세션을 다시 시작
//        startBackgroundSession()
    }
    static let shared = WatchSessionManager() // 싱글톤 인스턴스 생성
    
    @Published var alertMessage: String = "대기 중"
//    private var backgroundSession: WKExtendedRuntimeSession?

    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
//        startBackgroundSession() // 백그라운드 세션 시작
    }

    // 백그라운드 실행을 위한 세션 시작
//    private func startBackgroundSession() {
//        backgroundSession = WKExtendedRuntimeSession()
//        backgroundSession?.delegate = self
//        backgroundSession?.start()
//    }

    // iOS에서 경고 메시지를 수신하는 메서드
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let alert = message["alert"] as? String {
            DispatchQueue.main.async {
                print("watch alarm 감지:", alert)
                self.alertMessage = alert
                WKInterfaceDevice.current().play(.notification) // 진동 알림 발생
                self.showAlert(alertMessage: alert)
            }
        }
    }

    // 알림 팝업을 표시하는 메서드
    private func showAlert(alertMessage: String) {
        let action = WKAlertAction(title: "확인", style: .default) { }
        
        // 현재 활성화된 인터페이스 컨트롤러에서 경고를 표시
        if let controller = WKExtension.shared().visibleInterfaceController {
            controller.presentAlert(withTitle: "경고", message: alertMessage, preferredStyle: .alert, actions: [action])
        }
    }

//    // WKExtendedRuntimeSessionDelegate - 세션 시작
//    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
//        print("배경 세션 시작됨")
//    }
//    
//    // WKExtendedRuntimeSessionDelegate - 세션 만료 예정
//    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
//        print("배경 세션 만료 예정")
//    }
//
//    // WKExtendedRuntimeSessionDelegate - 세션 만료 후 다시 시작
//    func extendedRuntimeSessionDidInvalidate(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
//        print("배경 세션 만료됨")
//        startBackgroundSession() // 세션 만료 시 다시 시작
//    }

    // WCSession 활성화 완료 시 호출되는 메서드
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("애플워치 - WCSession 활성화 완료. 상태: \(activationState.rawValue)")
        if let error = error {
            print("애플워치 - 활성화 오류: \(error.localizedDescription)")
        }
    }
}
